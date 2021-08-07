FROM docker:latest

ENV TZ=Europe/London

RUN apk update  && \
    apk upgrade && \
    apk add \
        curl \
        yarn \
        wget \
        sudo \
        openrc && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    wget https://github.com/cdr/code-server/releases/download/2.1698/code-server2.1698-vsc1.41.1-alpine-x86_64.tar.gz && \
    tar -xvzf code-server2.1698-vsc1.41.1-alpine-x86_64.tar.gz && \
    mv /tmp/code-server2.1698-vsc1.41.1-alpine-x86_64 /opt/code-server2.1698-vsc1.41.1-alpine-x86_64 && \
    cd / && \
    chmod +x /opt/code-server2.1698-vsc1.41.1-alpine-x86_64/code-server && \
    ln -s ../../../opt/code-server2.1698-vsc1.41.1-alpine-x86_64/code-server /usr/local/bin/code-server
#     service /usr/local/bin/code-server start
