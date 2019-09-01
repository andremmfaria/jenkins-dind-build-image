# linux-dind-build-image

This docker image is a DIND made to be used as a build slave to create other docker images programatically by an orchestrator. E.g. jenkins, GoCd, etc.

As the container orchestration world rises there is a need to create containerized applications on the fly, this image eases this process.

## Usage

The orchestrator instance creates and connects to this instance via SSH over user/password combination.

### User/Password:

The image is already configured to use user and passord as follows:

```
usr: root
psw: lJe2u2P+iMk0lyCNHsEM39Sxe0+0R+x6Urkdhno5ffw=
```

## Thanks

I have copied a part of this from someone on github. As i do not remember from who, thanks my friend :D
