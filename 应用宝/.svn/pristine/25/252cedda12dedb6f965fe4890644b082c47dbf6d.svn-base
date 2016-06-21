#!/bin/bash

#set -x

echo "Init Enviroment"

BUILD_SHELL_PATH=$(dirname "$0")
#echo $BUILD_SHELL_PATH
#切换到脚本路径
cd $BUILD_SHELL_PATH



#切换到browser项目
cd browser
BROWSER_PRG_PATH=$(pwd)
#echo $BROWSER_PRG_PATH

BUILD_DIR=$BROWSER_PRG_PATH"/build"
BROWSER_APP_PATH=$BROWSER_PRG_PATH"/build/Release-iphoneos/快用手机助手.app"
INFOPLIST=$BROWSER_APP_PATH"/Info.plist"
BUILDPLIST=$BROWSER_APP_PATH"/build.plist"


rm  -rf ~/Desktop/BrowserProducts/temp
mkdir -p ~/Desktop/BrowserProducts/temp/Payload



#增加build号
#提取当前BUILD号
BUILD_NUM=$(plutil -p  ${BROWSER_PRG_PATH}"/browser/build.plist")
#BUILD号增加
num=$(expr "${BUILD_NUM}" : '.*=>.\([^}]*\).*')
let num++
#更新build号
plutil -replace  build  -integer $num   ${BROWSER_PRG_PATH}"/browser/build.plist"




echo "Clean browser..."
xcodebuild clean -sdk iphoneos9.1 -configuration Release  1>/dev/null
#2>/dev/null
if [ $? -ne 0 ]; then
  echo "Clean Failed"
 exit 0
fi

echo "Build browser..."
xcodebuild  -sdk iphoneos9.1 -configuration Release   1>/dev/null
#2>/dev/null
if [ $? -ne 0 ]; then
    echo "failed"
    exit 0
fi

#获取项目信息
InfoPlist=`plutil -p ${INFOPLIST}`
BuildPlist=`plutil -p ${BUILDPLIST}`
version=$(expr "${InfoPlist}" : '.*\"CFBundleShortVersionString\".=>.\"\([^"]*\).*')
build=$(expr "${BuildPlist}" : '.*=>.\([^}]*\).*')

IPA_NAME="my_"${version}"_"${build}".ipa"

echo $IPA_NAME


#打包
mv  $BROWSER_APP_PATH   ~/Desktop/BrowserProducts/temp/Payload
cd ~/Desktop/BrowserProducts/temp
zip -r  ./${IPA_NAME}   *

mv ./${IPA_NAME}   ../
echo ""
echo -e "\033[44;37;10m生成"~/Desktop/BrowserProducts/"${IPA_NAME}成功\033[0m"

rm -rf  $BUILD_DIR
rm -rf ~/Desktop/BrowserProducts/temp