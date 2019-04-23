FROM docker:dind
LABEL MAINTAINER="Andre Faria<andremarcalfaria@gmail.com>"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}

ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

# setup SSH server
RUN apk update && \
    apk add --no-cache sudo bash nss openjdk8 openssh git curl wget
RUN sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication yes/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' && \
    mkdir /var/run/sshd && \
    echo "%${group} ALL=(ALL) NOPASSWD: /usr/local/bin/docker" >> /etc/sudoers

# Add user and group jenkins to the image, change it's password and create m2 folder
RUN addgroup -g ${gid} ${group} && \
    adduser -D -h "${JENKINS_AGENT_HOME}" -u "${uid}" -G "${group}" -s /bin/bash "${user}" && \
    echo "jenkins:jenkins" | chpasswd

#Update credential for Jenkins user
RUN delgroup ping && \
    addgroup -g 999 docker && \
    addgroup jenkins docker && \
    ln -s /usr/local/bin/docker /usr/bin/docker

VOLUME "${JENKINS_AGENT_HOME}" "/tmp" "/run" "/var/run"
WORKDIR "${JENKINS_AGENT_HOME}"

COPY entrypoint "${JENKINS_AGENT_HOME}/entrypoint"

EXPOSE 22

ENTRYPOINT ["bash","entrypoint"]