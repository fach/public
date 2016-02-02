#!/bin/bash

function join () {
local IFS="$1"
shift
echo "$*" 
}

IETF_PATH="../../yang/standard/ietf/RFC"
OC_DIRS=($(find . -maxdepth 1 -type d | cut -d "/" -f2))
OC_PATHS=$(join : "${OC_DIRS[@]}")

function validate () {
RETCODE=0
for i in `find . -name "*.yang"`;
do
    printf "Validating $i..."
    OUTPUT=$(pyang --strict --lint -p $OC_PATHS -p $IETF_PATH $i 2>&1 > /dev/null)
    STATUS=$?
    if [ $STATUS -ne 0 ]; then
        RETCODE=1
        printf "FAILED\n"
        printf "$OUTPUT\n"
    else
        printf "OK\n"
    fi
done
return $RETCODE
}

validate
