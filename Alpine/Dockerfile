FROM docker:latest

ENV TZ=Europe/London

RUN apk update  && \
    apk upgrade && \
    apk add \
        curl \
        yarn \
        wget \
        ansible \
        sudo \
        openrc && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && 