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

#####################################
# INCREASE VERSION AND AINT TO ICON  #
#####################################

#buildkit bk_config.yml

##########
# CLEAN  #
##########
xctool -workspace CIP.xcworkspace -scheme CIP -configuration Debug -sdk iphonesimulator7.0 -destination platform='iOS Simulator',OS=7.0,name='iPhone Retina (4-inch)' clean

if test $? -eq 0
     then
        echo -e "${GREEN}CLEAN PASSED"
     else
        echo -e "${RED}CLEAN FAILED"
		echo -e "${NONE}"
		exit 1
     fi

echo -e "${GREEN}STARTING BUILD"
echo -e "${NONE}"

##########
# BUILD  #
##########
xctool -workspace CIP.xcworkspace -scheme CIP -configuration Debug -sdk iphonesimulator7.0 -destination platform='iOS Simulator',OS=7.0,name='iPhone Retina (4-inch)'

if test $? -eq 0
     then
        echo -e "${GREEN}BUILD PASSED"
     else
        echo -e "${RED}BUILD FAILED"
		echo -e "${NONE}"
		exit 1
     fi

echo -e "${GREEN}STARTING UNIT TESTS"
echo -e "${NONE}"

##########
# TEST  #
##########
xctool -workspace CIP.xcworkspace -scheme CIP -configuration Debug -sdk iphonesimulator7.0 -destination platform='iOS Simulator',OS=7.0,name='iPhone Retina (4-inch)' test

if test $? -eq 0
then
echo -e "${GREEN}TEST PASSED"
else
echo -e "${RED}TEST FAILED"
echo -e "${NONE}"
exit 1
fi

##########
# BUILD FOR RELEASE  #
##########
xctool -workspace CIP.xcworkspace -scheme CIP -configuration Release -sdk iphoneos

if test $? -eq 0
then
echo -e "${GREEN}BUILD FOR RELEASE PASSED"
else
echo -e "${RED}BUILD FOR RELEASE FAILED"
echo -e "${NONE}"
exit 1
fi

##########
# ARCHIVE  #
##########

ipa build

if test $? -eq 0
then
echo -e "${GREEN}ARCHIVE PASSED"
else
echo -e "${RED}ARCHIVE FAILED"
echo -e "${NONE}"
exit 1
fi

echo -e "${NONE}"
