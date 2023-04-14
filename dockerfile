# FROM ubuntu:focal
FROM debian:11-slim

RUN apt-get update
RUN apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install unzip zip curl ca-certificates \
  git openjdk-11-jdk gnupg openssh-client docker.io procps \
  # for website monitoring
  chromium chromium-sandbox \
  # for aws-cli
  python3 python3-pip \
  # for github actions runner
  libicu67 tzdata \
  # for building some react native packages
  build-essential

### add user account
RUN adduser --disabled-password --gecos "" user1

### copy main script into container
COPY entry.sh /opt/entry.sh


### Setup docker to use host docker daemon for all container users
# IP address below is for the first additional docker network created
# The default network will have an IP of 172.17.0.1 instead
RUN echo "## NOT USED export DOCKER_HOST=tcp://172.18.0.1:2375" > /etc/profile.d/common.sh


### Setup Node JS for user1
ENV NVM_DIR=/home/user1/.nvm
ENV NODE_VERSION=18.15.0
ENV NODE_PATH=$NVM_DIR/v${NODE_VERSION}/lib/node_modules
ENV PATH=${PATH}:${NVM_DIR}/versions/node/v${NODE_VERSION}/bin

RUN su user1 -c "/opt/entry.sh install-nvm"


### Setup Android SDK for user1
ENV ANDROID_PLATFORM_VER=33
ENV ANDROID_BUILD_TOOL_VER=33.0.0
ENV ANDROID_HOME=/home/user1/.android/sdk
ENV ANDROID_SDK="${ANDROID_HOME}"
ENV ANDROID_SDK_ROOT="${ANDROID_HOME}"
ENV ANDROID_PREFS_ROOT="${ANDROID_HOME}"

ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin"
ENV PATH="${PATH}:${ANDROID_HOME}/platform-tools"
ENV PATH="${PATH}:${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOL_VER}"
ENV PATH="${PATH}:${ANDROID_HOME}/ndk-bundle"
ENV PATH="${PATH}:${ANDROID_HOME}/cmake/3.18.1/bin"

RUN echo "\n\
export ANDROID_PLATFORM_VER=${ANDROID_PLATFORM_VER}\n\
export ANDROID_BUILD_TOOL_VER=${ANDROID_BUILD_TOOL_VER}\n\
export ANDROID_HOME=${ANDROID_HOME}\n\
export ANDROID_SDK=${ANDROID_HOME}\n\
export ANDROID_SDK_ROOT=${ANDROID_HOME}\n\
export ANDROID_PREFS_ROOT=${ANDROID_HOME}\n\
" >> /etc/profile.d/common.sh

RUN su user1 -c "/opt/entry.sh install-sdk"


### Setup AWS CLI for user1
ENV PATH="${PATH}:/home/user1/aws-cli/bin"
RUN su user1 -c "/opt/entry.sh install-aws-cli"

RUN echo "export PATH=\"$PATH\"" >> /etc/profile.d/common.sh


# folder for transferring data between host and container
RUN mkdir /opt/data

ENTRYPOINT ["/opt/entry.sh"]
CMD ["/bin/sh"]

# run it
WORKDIR /opt

