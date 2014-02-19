#!/bin/bash
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

echo -e "${GREEN}STARTING CLEAN"
echo -e "${NONE}"

echo -e "${PURPLE}##############################################"
echo -e "${PURPLE}#                    CLEAN                   #"
echo -e "${PURPLE}##############################################"
echo -e "${NONE}"

xctool -workspace CIP.xcworkspace -scheme CIP -configuration Debug -sdk iphonesimulator7.0 -destination platform='iOS Simulator',OS=7.0,name='iPhone Retina (4-inch)' clean

if test $? -eq 0
     then
        echo -e "${GREEN}CLEAN PASSED"
     else
        echo -e "${RED}CLEAN FAILED"
		echo -e "${NONE}"
		exit 1
     fi


echo -e "${PURPLE}##############################################"
echo -e "${PURPLE}#                    BUILD                   #"
echo -e "${PURPLE}##############################################"
echo -e "${NONE}"

xctool -workspace CIP.xcworkspace -scheme CIP -configuration Debug -sdk iphonesimulator7.0 -destination platform='iOS Simulator',OS=7.0,name='iPhone Retina (4-inch)'

if test $? -eq 0
     then
        echo -e "${GREEN}BUILD PASSED"
     else
        echo -e "${RED}BUILD FAILED"
        echo -e "${NONE}"
        exit 1
     fi


echo -e "${PURPLE}##############################################"
echo -e "${PURPLE}#                    TEST                   #"
echo -e "${PURPLE}##############################################"
echo -e "${NONE}"

xctool -workspace CIP.xcworkspace -scheme CIP -configuration Debug -sdk iphonesimulator7.0 -destination platform='iOS Simulator',OS=7.0,name='iPhone Retina (4-inch)' test

if test $? -eq 0
then
echo -e "${GREEN}TEST PASSED"
else
echo -e "${RED}TEST FAILED"
echo -e "${NONE}"
exit 1
fi

echo -e "${PURPLE}##############################################"
echo -e "${PURPLE}#                  ARCHIVE                   #"
echo -e "${PURPLE}##############################################"
echo -e "${NONE}"

ipa build \
  --workspace CIP.xcworkspace \
  --scheme CIP \
  --embed ./Provisioning/IPS.mobileprovision \
  --clean \
  --archive

if test $? -eq 0
then
echo -e "${GREEN}ARCHIVE PASSED"
else
echo -e "${RED}ARCHIVE FAILED"
echo -e "${NONE}"
exit 1
fi

echo -e "${NONE}"
