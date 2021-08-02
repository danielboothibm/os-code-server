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
        jq 

RUN curl -fsSL https://code-server.dev/install.sh | sh
