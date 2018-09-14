FROM alpine:3.8

WORKDIR /opt/codesign-util

# version and sha256 hash of our 3rd party download
ENV VERSION     1.7.1
ENV SHA256_HASH f9a8cdb38b9c309326764ebc937cba1523a3a751a7ab05df3ecc99d18ae466c9

RUN set -x \
  && apk add --update curl build-base openssl-dev curl-dev autoconf libgsf-dev \
  && curl -s -L https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-$VERSION.tar.gz > osslsigncode-$VERSION.tar.gz \
  && sha256sum osslsigncode-$VERSION.tar.gz \
  && echo "$SHA256_HASH  osslsigncode-$VERSION.tar.gz" > SHA256SUM \
  && sha256sum -c SHA256SUM \
  && tar xzf osslsigncode-$VERSION.tar.gz \
  && cd osslsigncode-$VERSION \
  && ./configure \
  && make \
  && make install \
  && cd .. \
  && rm -rf osslsigncode-$VERSION \
  && apk del curl build-base autoconf \
  && rm -rf /var/cache/apk/*

VOLUME /mnt/certs
VOLUME /mnt/binaries

ENTRYPOINT ["/usr/local/bin/osslsigncode"]
