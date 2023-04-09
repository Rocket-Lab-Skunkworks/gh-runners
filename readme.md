# Description

This repository contains a script to generate a docker container that is suitable to use as a github self-host runner.

Software installed is capable of building Android mobile apps.

NodeJS is installed via the nvm version manager to allow switching between different versions. (Default is 18.15.0)

Container can also access host docker daemon to build docker images


## Usage:

### Build docker container
```
./run build
```

### Run container for first time
```
./run start
```

### after container first started, go into container to install the Github Actions agent
```
./run term
```

### Inside container, switch to normal user account, then run install script
```
su - user1
/opt/entry.sh install-gh
cd actions-runner
```

### Configure github runner with token given in website
```
./config.sh --url https://github.com/TheRocketLab --token XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

### Exit from user and container after entering details
```
logout
exit
```

### Restart container
```
./run stop ; ./run start
```


