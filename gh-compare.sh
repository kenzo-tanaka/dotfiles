#!/bin/bash

REMOTE=`git config --get remote.origin.url`
FROM_COMMIT=`git rev-parse HEAD~$1`
TO_COMMIT=`git rev-parse HEAD`

if [[ ${REMOTE} =~ ^https ]]; then
    REMOTE_URL=`echo ${REMOTE} | sed -e "s/.git//g"`
else
    REMOTE_URL="https://"`echo ${REMOTE} | sed -e "s/.git//g" | sed -e "s/:/\//g"`
fi

echo "${REMOTE_URL}/compare/${FROM_COMMIT}...${TO_COMMIT}"
