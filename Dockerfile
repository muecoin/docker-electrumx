FROM python:3.6-alpine3.6
LABEL maintainer="Sotiris Blad <swthrhs@protonmail.com>"

COPY ./bin /usr/local/bin
COPY ./VERSION /tmp

RUN VERSION=$(cat /tmp/VERSION) && \
    chmod a+x /usr/local/bin/* && \
    apk add --no-cache git build-base openssl && \
    apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing leveldb-dev && \
    pip install aiohttp pylru plyvel && \
    git clone -b $VERSION https://github.com/muecoin/electrumx-server-mue.git && \
    cd electrumx-server-mue && \
    python setup.py install && \
    apk del git build-base && \
    rm -rf /tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV ALLOW_ROOT 1
ENV DB_DIRECTORY /data
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx.key
ENV MAX_SESSIONS = 500
ENV COIN="MonetaryUnit"
ENV CACHE_MB = 128
ENV SERVICES=tcp://:50001,ssl://:50002
WORKDIR /data

EXPOSE 50001 50002

CMD ["init"]
