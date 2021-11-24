#!/usr/bin/env bash
#Place this script in project/ios/

# fail if any command fails
set -e
# debug log
set -x

cd ..
brew install yq
pwd
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor
git clone https://vio-devops-ro:Amj7923uskSjzsd@bitbucket.org/ventechgmi/myfhb-flutter-common.git
gmiwidget_path="`pwd`/myfhb-flutter-common"
ls -ltrh
yq e ".dependencies.gmiwidgetspackage.path = \"${gmiwidget_path}\"" -i pubspec.yaml
rm -Rf ios/Pods
sed -i.bak "/TensorFlowLiteC/s|2.7.0|2.2.0|g" ios/Podfile.lock
flutter build ios --release --no-codesign