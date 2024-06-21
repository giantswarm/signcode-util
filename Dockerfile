FROM gsoci.azurecr.io/giantswarm/alpine:3.20.0 AS builder

WORKDIR /opt/codesign-util/

# Version and expected SHA256 hash of our 3rd party download
ARG OSSLSIGNCODE_VER=2.5
ENV SHA256_HASH 815a0e6dcc1cb327da0cbd22589269aae1191d278e3570cd6e4a7c12d9fabe92

# Dependencies
RUN apk add --update --no-cache curl build-base openssl-dev curl-dev autoconf libgsf-dev

# Download and verify osslsigncode source
RUN curl -s -L https://github.com/mtrojnar/osslsigncode/releases/download/$OSSLSIGNCODE_VER/osslsigncode-$OSSLSIGNCODE_VER.0.tar.gz > osslsigncode-$OSSLSIGNCODE_VER.0.tar.gz
RUN sha256sum osslsigncode-$OSSLSIGNCODE_VER.0.tar.gz
RUN echo "$SHA256_HASH  osslsigncode-$OSSLSIGNCODE_VER.0.tar.gz" > SHA256SUM
RUN sha256sum -c SHA256SUM

# Unpack and build
RUN tar xzf osslsigncode-$OSSLSIGNCODE_VER.0.tar.gz
RUN cd osslsigncode-$OSSLSIGNCODE_VER.0 \
    && ./configure \
    && make \
    && make install


FROM gsoci.azurecr.io/giantswarm/alpine:3.20.0

WORKDIR /usr/local/bin/

RUN apk add --no-cache ca-certificates curl-dev libgsf-dev openssl-dev

COPY --from=builder /usr/local/bin/osslsigncode .

VOLUME /mnt/certs
VOLUME /mnt/binaries

ENTRYPOINT ["/usr/local/bin/osslsigncode"]
