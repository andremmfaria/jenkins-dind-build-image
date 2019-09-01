FROM docker:dind
LABEL MAINTAINER="Andre Faria<andremarcalfaria@gmail.com>"

ENV GENERIC_SONAR_SCANNER_VERSION=3.3.0.1492 \
    GENERIC_SONAR_SCANNER_HOME=/opt/generic-sonar-scanner \
    DOTNET_SONAR_SCANNER_VERSION=4.6.2.2108 \
    DOTNET_SONAR_SCANNER_HOME=/opt/dotnet-sonar-scanner 

ENV DOTNET_SONAR_SCANNER_DLL=${DOTNET_SONAR_SCANNER_HOME}/SonarScanner.MSBuild.dll \
    PATH=$PATH:${GENERIC_SONAR_SCANNER_HOME}/bin

# Install necessary packages
RUN apk update && \
    apk add --no-cache bash nss openjdk8 openssh git curl wget unzip

# Configure SSHd
RUN sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin yes/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication yes/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' && \
    mkdir /var/run/sshd && \
    echo "root:lJe2u2P+iMk0lyCNHsEM39Sxe0+0R+x6Urkdhno5ffw=" | chpasswd

# Install Sonar-Scanner
RUN mkdir /tmp/tempdownload && \
    curl -o /tmp/tempdownload/scanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${GENERIC_SONAR_SCANNER_VERSION}-linux.zip && \
    unzip /tmp/tempdownload/scanner.zip -d /tmp/tempdownload && \
    mv /tmp/tempdownload/$(ls /tmp/tempdownload | grep sonar-scanner) ${GENERIC_SONAR_SCANNER_HOME} && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' ${GENERIC_SONAR_SCANNER_HOME}/bin/sonar-scanner && \
    ln -s ${GENERIC_SONAR_SCANNER_HOME}/bin/sonar-scanner /usr/bin/sonar-scanner && \
    rm -rf /tmp/tempdownload

# Install .net core sonar scanner
RUN mkdir /opt/dotnet-sonar-scanner && \
    curl -o ${DOTNET_SONAR_SCANNER_HOME}/scanner.zip -L https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/${DOTNET_SONAR_SCANNER_VERSION}/sonar-scanner-msbuild-${DOTNET_SONAR_SCANNER_VERSION}-netcoreapp2.0.zip && \
    unzip ${DOTNET_SONAR_SCANNER_HOME}/scanner.zip -d ${DOTNET_SONAR_SCANNER_HOME} && \
    chmod +x -R ${DOTNET_SONAR_SCANNER_HOME} && \
    rm -rf ${DOTNET_SONAR_SCANNER_HOME}/scanner.zip

# Configure stuff
RUN delgroup ping && \
    ln -s /usr/local/bin/docker /usr/bin/docker && \
    sed -i /etc/passwd -e '/root/s/ash/bash/g'

WORKDIR "/root"

COPY entrypoint.sh "/root/entrypoint.sh"

EXPOSE 22

ENTRYPOINT ["bash","entrypoint.sh"]
