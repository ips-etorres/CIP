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

echo -e "${YELLOW}##############################################"
echo -e "${YELLOW}#         Display depencencies version       #"
echo -e "${YELLOW}##############################################"
echo 
echo
echo -e "${YELLOW}############ xcodebuild version ##############"
echo -e "${NONE}"

if [ -d "/Applications/Xcode.app" ] && 
   [ $(xcodebuild -version | grep -c "5\\.") -eq 1 ]
then
  echo " + Xcode 5 found."
else
  echo " x Xcode 5 not found."
  echo "   Install Xcode 5 from the Mac App Store."
  exit 1
fi

echo -e "${YELLOW}############ Ruby version ##############"
echo -e "${NONE}"

if test ! $(which ruby)
then
  echo " x You need to install Ruby >= 2.0.0"
  exit 1
else
  if [ $(ruby -e 'puts RUBY_VERSION' | grep -c "2\\.0\\.0") -eq 1 ]
  then
    echo " + Ruby 2.0.0 found."
  else
    echo " + Ruby $(ruby -e 'puts RUBY_VERSION') found."
    echo " - Ruby 2.0.0 is recommended."
  fi
fi

echo -e "${YELLOW}############ xctool version ##############"
echo -e "${NONE}"
xctool -version
echo 
echo
echo -e "${YELLOW}############ Cocoapods version ##############"
echo -e "${NONE}"
pod --version
echo 
echo
echo -e "${YELLOW}############ Shenzen version ##############"
echo -e "${NONE}"
ipa --version
echo 
echo
echo -e "${YELLOW}######## codesigning find-identity ###########"
echo -e "${NONE}"
security find-identity -p codesigning -v
echo 
echo
echo -e "${YELLOW}########### Project version #################"
echo -e "${NONE}"
agvtool mvers -terse1
echo 
echo
echo -e "${YELLOW}########### Show SDKs #################"
echo -e "${NONE}"
xcodebuild -showsdks
echo 
echo
echo -e "${YELLOW}########### Show Schemes #################"
echo -e "${NONE}"
xcodebuild -list -workspace CIP.xcworkspace
echo 
echo
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
