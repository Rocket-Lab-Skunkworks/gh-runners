# Description

Files in this repository help setup custom github runners to build Android and Mac OS mobile apps.

Android system can also run deployments to AWS via the AWS cli tool

# Usage - Android
To create a new runner follow these steps:
```
# Create a folder in the location you want to place the contents for the container.  Usually in a folder with same name as container
mkdir -p $HOME/vmc/lnx-vm99
cd $HOME/vmc/lnx-vm99

# Get the two script files
curl -O https://raw.githubusercontent.com/Rocket-Lab-Skunkworks/gh-runners/refs/heads/main/android-v3/run
curl -O https://raw.githubusercontent.com/Rocket-Lab-Skunkworks/gh-runners/refs/heads/main/android-v3/setup.sh

# make them executable
chmod ug+x run setup.sh

# Edit the run file with the name of the container: APP_NAME=lnx-vm99
# Once set and saved, run the container
./run start

# Go into the empty container
./run term

# run setup script to install all requireed software inside the container
/opt/setup.sh install-all

# after install, configure your github runner as the normal container user
su - user1
cd /opt/apps/gh/actions-runner
# get this line from github
./config.sh --url https://github.com/js-rocket-org --token XXXXXXXXXXXXXXXX

# exit user, then container
exit
exit

# restart container
./run stop
./run start

# check log to see if github agent is running
./run log

```


