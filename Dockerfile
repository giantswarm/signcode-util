FROM alpine:3.6

WORKDIR /opt/codesign-util

RUN apk add --update curl build-base openssl-dev curl-dev autoconf libgsf-dev \
  && curl -L https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz > osslsigncode-1.7.1.tar.gz \
  && tar xvzf osslsigncode-1.7.1.tar.gz \
  && cd osslsigncode-1.7.1 \
  && ./configure \
  && make \
  && make install \
  && cd .. \
  && rm -rf osslsigncode-1.7.1 \
  && apk del curl build-base autoconf \
  && rm -rf /var/cache/apk/*

VOLUME /mnt/certs
VOLUME /mnt/binaries

ENTRYPOINT ["/usr/local/bin/osslsigncode"]
