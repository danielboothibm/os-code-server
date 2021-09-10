FROM ubuntu:latest

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    TZ=Europe/London \
    oc_version="v3.11.0" \
    oc_version_commit="0cbc58b" \
    PATH="${PATH}:/home/coder/.local/bin"

COPY exec /opt

RUN . /etc/lsb-release && \
    apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && \
    apt-get install -y curl locales gnupg2 tzdata && locale-gen en_US.UTF-8 && \
    curl -sL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get upgrade -y && \
    apt-get install -y  \
      sudo \
      jq \
      git \
      locales \ 
      dumb-init \
      wget \
      python3-pip \
      ansible \
      bash-completion \
      rsync \
      nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

RUN locale-gen en_US.UTF-8 && \
    npm install --global yarn && \
    cd /tmp && \
# install code-server
    ansible localhost -m apt -a "deb=$(curl -s https://api.github.com/repos/cdr/code-server/releases/latest |  jq -r '.assets[] | select(.browser_download_url | contains("amd64.deb")) | .browser_download_url')" && \
# install openshift/kubernetes client tools
    wget -O - https://github.com/openshift/origin/releases/download/${oc_version}/openshift-origin-client-tools-${oc_version}-${oc_version_commit}-linux-64bit.tar.gz | tar -xzv --strip 1 openshift-origin-client-tools-${oc_version}-${oc_version_commit}-linux-64bit/oc openshift-origin-client-tools-${oc_version}-${oc_version_commit}-linux-64bit/kubectl && \
    mv oc kubectl /usr/bin/ && \
    /usr/bin/oc completion bash >> /etc/bash_completion.d/oc_completion && \
    /usr/bin/kubectl completion bash >> /etc/bash_completion.d/kubectl_completion && \
# for openvpn
    mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    chmod 600 /dev/net/tun && \
    echo "user ALL=(ALL) NOPASSWD: /usr/sbin/openvpn --config /home/coder/projects/.openvpn/openvpn-client-conf.ovpn" >> /etc/sudoers.d/openvpn-client && \
# add user coder
    chattr -i /etc/resolv.conf && \
    adduser --disabled-password --gecos '' coder && \
    echo '%sudo ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd && \
    chmod g+rw /home/coder && \
    chmod a+x /opt/exec && \
    chgrp -R 0 /home/coder /etc/ansible && \
    chmod g=u /etc/passwd /etc/ssl/certs/ca-certificates.crt /etc/resolv.conf && \
    chmod -R g=u /home/coder /etc/ansible /etc/resolv.conf

ENV LC_ALL=en_US.UTF-8

WORKDIR /home/coder

USER coder

RUN mkdir -p projects && mkdir -p certs && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash && \
    sudo chmod -R g+rw projects/ && \
    sudo chmod -R g+rw certs/ && \
    sudo chmod -R g+rw .nvm && \
    sudo rm -frv .config/ && \
    sudo chgrp -R 0 /home/coder

COPY entrypoint /home/coder

VOLUME ["/home/coder/projects", "/home/coder/certs"];

USER 10001

ENTRYPOINT ["/home/coder/entrypoint"]

EXPOSE 9000

CMD ["/opt/exec"]

