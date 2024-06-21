FROM gsoci.azurecr.io/giantswarm/alpine:3.20.0 AS builder

WORKDIR /opt/codesign-util/

# Version and expected SHA256 hash of our 3rd party download
ARG OSSLSIGNCODE_VER=2.8
ENV SHA256_HASH d275d86bf0a8094e2c2ea451065299f965238be3cfaf3af6aff276302d759354

# Dependencies
RUN apk add --update --no-cache curl build-base cmake openssl-dev curl-dev autoconf libgsf-dev

# Download and verify osslsigncode source
RUN curl -s -L https://github.com/mtrojnar/osslsigncode/archive/refs/tags/$OSSLSIGNCODE_VER.tar.gz > osslsigncode-$OSSLSIGNCODE_VER.tar.gz
RUN sha256sum osslsigncode-$OSSLSIGNCODE_VER.tar.gz
RUN echo "$SHA256_HASH  osslsigncode-$OSSLSIGNCODE_VER.tar.gz" > SHA256SUM
RUN sha256sum -c SHA256SUM

# Unpack and build
# Adapted from https://github.com/mtrojnar/osslsigncode/blob/2.8/Dockerfile
RUN tar xzf osslsigncode-$OSSLSIGNCODE_VER.tar.gz
RUN cd osslsigncode-$OSSLSIGNCODE_VER \
    && mkdir build \
    && cd build \
    && cmake -S .. \
    && cmake --build . && \
    && cmake --install .

FROM gsoci.azurecr.io/giantswarm/alpine:3.20.0

WORKDIR /usr/local/bin/

RUN apk add --no-cache ca-certificates curl-dev libgsf-dev openssl-dev

COPY --from=builder /usr/local/bin/osslsigncode .

VOLUME /mnt/certs
VOLUME /mnt/binaries

ENTRYPOINT ["/usr/local/bin/osslsigncode"]
