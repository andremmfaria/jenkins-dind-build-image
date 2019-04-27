# jenkins-dind-build-image

This docker image is a DIND made to be used as a jenkins build slave to create other docker images programatically.

As the container orchestration world rises there is a need to create containerized applications on the fly, this image facilitates this process.

## Usage

The jenkins instance creates and connects to this instance via SSH. However this can be achieved by user/password combination or public/private keys configuration. 

### User/Password:

The image is already configured to use user and passord as follows:

```
usr: jenkins
psw: jenkins
```

### Public/private keys:

You need only to change this line on the Dockerfile:

from:
```
-e 's/#PasswordAuthentication.*/PasswordAuthentication yes/' \
```

to:
```
-e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
```

And configure the private key credentials on your jenkins
Obs: This disables the user/password config

## Thanks

I have copied a part of this from someone on github. As i do not remember from who, thanks my friend :D
