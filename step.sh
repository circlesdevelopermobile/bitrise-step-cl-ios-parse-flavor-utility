#!/bin/bash
set -ex


# getTargetUnderTest: takes in country as input and sets enbv relevant TARGET_UNDER_TEST value
function setTargetEnvVars() {
  COUNTRY=$1
  TEST_TARGET_PREFIX="Selfcare"
  TEST_APP_COUNTRY_PREFIX="APP_COUNTRY_"
  case "${COUNTRY}" in
    "au")
      envman add --key TARGET_UNDER_TEST --value "${TEST_TARGET_PREFIX}-Australia"
      envman add --key TARGET_APP_COUNTRY --value "${TEST_APP_COUNTRY_PREFIX}AUSTRALIA"
      return 0
      ;;
    "sg")
      envman add --key TARGET_UNDER_TEST --value "${TEST_TARGET_PREFIX}"
      envman add --key TARGET_APP_COUNTRY --value "${TEST_APP_COUNTRY_PREFIX}SINGAPORE"
      return 0
      ;;
    "tw")
      envman add --key TARGET_UNDER_TEST --value "${TEST_TARGET_PREFIX}-Taiwan"
      envman add --key TARGET_APP_COUNTRY --value "${TEST_APP_COUNTRY_PREFIX}TAIWAN"
      return 0
      ;;
    "id")
      envman add --key TARGET_UNDER_TEST --value "${TEST_TARGET_PREFIX}-Indonesia"
      envman add --key TARGET_APP_COUNTRY --value "${TEST_APP_COUNTRY_PREFIX}INDONESIA"
      return 0
      ;;
    *)
      envman add --key TARGET_UNDER_TEST --value "${TEST_TARGET_PREFIX}"
      envman add --key TARGET_APP_COUNTRY --value "${TEST_APP_COUNTRY_PREFIX}SINGAPORE"
      return 0
      ;;
  esac
}

GIT_DESTINATION_BRANCH=${bitrise_git_dest}
echo "------------------------"
echo "Routing received PR trigger - ${GIT_DESTINATION_BRANCH}"
echo "------------------------"

SUPPORTED_COUNTRIES=${supported_countries}
SUPPORTED_COUNTRIES_LOWERCASE=`echo "${SUPPORTED_COUNTRIES}" | tr '[:upper:]' '[:lower:]'`
TAG_REGEX="(${SUPPORTED_COUNTRIES_LOWERCASE})-master"

if [ -z "$GIT_DESTINATION_BRANCH" ]; then
    echo "Error: BITRISE_GIT_DESTINATION_BRANCH environment variable not found"
    exit 1
elif [[ $GIT_DESTINATION_BRANCH =~ $TAG_REGEX ]]; then
    COUNTRY="${BASH_REMATCH[1]}"
    FLAVOR="${COUNTRY}.qa"

    envman add --key PR_UNIT_TEST_ENVIRONMENT --value "${FLAVOR}"
    setTargetEnvVars $COUNTRY
    exit 0
else
    echo "Error: Invalid Branch - ${GIT_DESTINATION_BRANCH}"
    exit 1
fi
