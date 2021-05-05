#!/bin/bash
set -ex

echo "This is the value specified for the input 'example_step_input': ${example_step_input}"


TAG=${bitrise_git_tag}

echo "Routing received tag trigger..."
echo "------------------------"
echo "TAG: ${TAG}"
echo "OPTION: ${OPTION}"
echo "------------------------"

if [ -z "$TAG" ]; then
    echo "Error: BITRISE_GIT_TAG environment variable not found"
    exit 1
elif [[ $TAG =~ -(AS|RC[0-9]+)-(SG|ID|TW|AU|JP)$ ]]; then
    COUNTRY="${BASH_REMATCH[2]}"
    COUNTRY=`echo "${COUNTRY}" | tr '[:upper:]' '[:lower:]'`
    TAG_TYPE="${BASH_REMATCH[1]}"
    if [ "${TAG_TYPE}" = "AS" ]; then
        FLAVOR="${COUNTRY}"
    else
        FLAVOR="${COUNTRY}.qa"
    fi
    
    envman add --key FASTLANE_ENV --value "${FLAVOR}"
    exit 0
else
    echo "Error: invalid input tag/option"
    exit 1
fi

 
