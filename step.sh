#!/bin/bash
set -ex

GIT_DESTINATION_BRANCH=${bitrise_git_tag}
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
    COUNTRY=`echo "${COUNTRY}" | tr '[:upper:]' '[:lower:]'`
    FLAVOR="${COUNTRY}.qa"

    envman add --key PR_UNIT_TEST_ENVIRONMENT --value "${FLAVOR}"
    exit 0
else
    echo "Error: Invalid Tag - ${GIT_DESTINATION_BRANCH}"
    exit 1
fi
