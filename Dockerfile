FROM gsoci.azurecr.io/giantswarm/alpine:3.20.3 AS builder

WORKDIR /opt/codesign-util/

# Version and expected SHA256 hash of our 3rd party download
ENV VERSION     2.3
ENV SHA256_HASH b73a7f5a68473ca467f98f93ad098142ac6ca66a32436a7d89bb833628bd2b4e

# Dependencies
RUN apk add --update --no-cache curl build-base openssl-dev curl-dev autoconf libgsf-dev

# Download and verify osslsigncode source
RUN curl -s -L https://github.com/mtrojnar/osslsigncode/releases/download/$VERSION/osslsigncode-$VERSION.0.tar.gz > osslsigncode-$VERSION.0.tar.gz
RUN sha256sum osslsigncode-$VERSION.0.tar.gz
RUN echo "$SHA256_HASH  osslsigncode-$VERSION.0.tar.gz" > SHA256SUM
RUN sha256sum -c SHA256SUM

# Unpack and build
RUN tar xzf osslsigncode-$VERSION.0.tar.gz
RUN cd osslsigncode-$VERSION.0 \
    && ./configure \
    && make \
    && make install


FROM gsoci.azurecr.io/giantswarm/alpine:3.20.3

WORKDIR /usr/local/bin/

RUN apk add --no-cache ca-certificates curl-dev libgsf-dev openssl-dev

COPY --from=builder /usr/local/bin/osslsigncode .

VOLUME /mnt/certs
VOLUME /mnt/binaries

ENTRYPOINT ["/usr/local/bin/osslsigncode"]
