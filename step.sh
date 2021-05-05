#!/bin/bash
set -ex

GIT_TAG=${bitrise_git_tag}
echo "------------------------"
echo "Routing received tag trigger - ${GIT_TAG}"
echo "------------------------"

SUPPORTED_COUNTRIES=${supported_countries}
TAG_REGEX="-(AS|RC[0-9]+)-(${SUPPORTED_COUNTRIES})$"

if [ -z "$GIT_TAG" ]; then
    echo "Error: BITRISE_GIT_TAG environment variable not found"
    exit 1
elif [[ $GIT_TAG =~ $TAG_REGEX ]]; then
    COUNTRY="${BASH_REMATCH[2]}"
    COUNTRY=`echo "${COUNTRY}" | tr '[:upper:]' '[:lower:]'`
    TAG_TYPE="${BASH_REMATCH[1]}"
    if [ "${TAG_TYPE}" = "AS" ]; then
        FLAVOR="${COUNTRY}"
    else
        FLAVOR="${COUNTRY}.qa"
    fi
    
    envman add --key TAG_ENVIRONMENT --value "${FLAVOR}"
    exit 0
else
    echo "Error: Invalid Tag - ${GIT_TAG}"
    exit 1
fi

 
