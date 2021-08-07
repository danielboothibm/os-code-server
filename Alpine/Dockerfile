FROM docker:latest

ENV TZ=Europe/London

RUN apk update  && \
    apk upgrade && \
    apk add \
        curl \
        yarn \
        wget \
        sudo \
        git \
        openrc && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    wget https://github.com/cdr/code-server/releases/download/2.1698/code-server2.1698-vsc1.41.1-alpine-x86_64.tar.gz && \
    tar -xvzf code-server2.1698-vsc1.41.1-alpine-x86_64.tar.gz && \
    mv code-server2.1698-vsc1.41.1-alpine-x86_64/code-server /usr/local/bin && \
    rm -rf code-server2.1698-vsc1.41.1-alpine-x86_64.tar.gz code-server2.1698-vsc1.41.1-alpine-x86_64 && \
    mkdir -p /home/code/projects

ENV HOME=/home/code/projects \
    PASSWORD=password

CMD [ "code-server" ]

EXPOSE 8080