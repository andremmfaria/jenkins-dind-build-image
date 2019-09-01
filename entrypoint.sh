#!/bin/bash
set -ex

env >> /etc/profile.d/dockerfile-internal.sh
env >> /etc/environment

ssh-keygen -A
/usr/sbin/sshd -e -D &

exec "$(which dind)" dockerd \
      --host=unix:///var/run/docker.sock \
      --host=tcp://0.0.0.0:2375
