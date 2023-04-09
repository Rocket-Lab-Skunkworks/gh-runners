#!/bin/sh

install_android_sdk() {
  # Version 30.7.2 - latest as at 1 June 2021
  # https://dl.google.com/android/repository/emulator-darwin_x64-7395805.zip
  # https://dl.google.com/android/repository/emulator-linux_x64-7395805.zip
  # https://dl.google.com/android/repository/emulator-windows_x64-7395805.zip
  CMDTOOLS_FILE=commandlinetools-linux-9477386_latest.zip
  EMULATOR_FILE=emulator-linux_x64-7395805.zip

  # change to sdkmanager for linux/mac or sdkmanager.bat for windows same for avdmanager
  SDKMAN=sdkmanager
  AVDMAN=avdmanager
  BASE_URL=https://dl.google.com/android/repository
  PREFIX=~

  # Download the minimum required file
  curl -o $PREFIX/$CMDTOOLS_FILE $BASE_URL/$CMDTOOLS_FILE
  mkdir -p $ANDROID_SDK/cmdline-tools
  unzip $PREFIX/$CMDTOOLS_FILE -d $ANDROID_SDK/cmdline-tools
  mv $ANDROID_SDK/cmdline-tools/cmdline-tools $ANDROID_SDK/cmdline-tools/latest
  rm -f $PREFIX/$CMDTOOLS_FILE

  # Install the minimum set of tools to compile an Android app
  # patcher:v4 and tools will be automatically installed
  yes | $SDKMAN platform-tools "platforms;android-$ANDROID_PLATFORM_VER" "build-tools;$ANDROID_BUILD_TOOL_VER" ndk-bundle \
    "ndk;25.2.9519653" "cmake;3.18.1" "build-tools;30.0.3" "platforms;android-30"
}

install_nvm() {
# export NVM_DIR=~/.nvm
# export NODE_VERSION=18.15.0
# export NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules
# export PATH=$NVM_DIR/v$NODE_VERSION/bin:$PATH

  cd ~/
# Install nvm with node and npm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
}

install_aws_cli() {
  # Installs the AWS command line tool if it does not exist
  cd ~/

  which aws
  if [ ! "$?" = "0" ]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install -i ~/aws-cli -b ~/aws-cli/bin
    export PATH=$PATH:~/aws-cli/bin
  fi
}

install_gh_runner() {
  GHA_VERSION="2.303.0"
  if [ "$(id -u)" = "0" ]; then echo "Do not install Github actions runner as root"; exit 255 ; fi

  cd ~/
  mkdir actions-runner && cd actions-runner
  curl -o actions-runner-linux-x64-$GHA_VERSION.tar.gz -L https://github.com/actions/runner/releases/download/v$GHA_VERSION/actions-runner-linux-x64-$GHA_VERSION.tar.gz
  tar xzf ./actions-runner-linux-x64-$GHA_VERSION.tar.gz
}

app_start() {
  if [ ! -f /home/user1/actions-runner/.credentials ]; then
    echo "Runner not configured, running shell"
    /bin/sh
  else
    echo "Running github runner"
    su user1 /home/user1/actions-runner/run.sh
  fi
}

if [ "$1" = "install-sdk" ]; then install_android_sdk; exit; fi
if [ "$1" = "install-nvm" ]; then install_nvm; exit; fi
if [ "$1" = "install-aws-cli" ]; then install_aws_cli; exit; fi
if [ "$1" = "install-gh" ]; then install_gh_runner; exit; fi
if [ "$1" = "start" ]; then app_start; exit; fi

exec $@
