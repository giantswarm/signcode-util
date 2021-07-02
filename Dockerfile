FROM quay.io/giantswarm/alpine:3.14 AS builder

WORKDIR /opt/codesign-util/

# Version and expected SHA256 hash of our 3rd party download
ENV VERSION     2.1
ENV SHA256_HASH c512931b6fe151297a1c689f88501e20ffc204c4ffe30e7392eb3decf195065b

# Dependencies
RUN apk add --update --no-cache curl build-base make openssl-dev curl-dev autoconf libgsf-dev

# Download and verify osslsigncode source
RUN curl -s -L https://github.com/mtrojnar/osslsigncode/releases/download/$VERSION/osslsigncode-$VERSION.0.tar.gz > osslsigncode-$VERSION.0.tar.gz
RUN sha256sum osslsigncode-$VERSION.0.tar.gz
RUN echo "$SHA256_HASH  osslsigncode-$VERSION.0.tar.gz" > SHA256SUM
RUN sha256sum -c SHA256SUM

# Unpack and build
RUN tar xzf osslsigncode-$VERSION.0.tar.gz

RUN cd osslsigncode-$VERSION.0 && ./configure --disable-dependency-tracking
RUN cd osslsigncode-$VERSION.0 && make
RUN cd osslsigncode-$VERSION.0 && make install


FROM quay.io/giantswarm/alpine:3.14

WORKDIR /usr/local/bin/

RUN apk add --no-cache ca-certificates curl-dev libgsf-dev openssl-dev

COPY --from=builder /usr/local/bin/osslsigncode .

VOLUME /mnt/certs
VOLUME /mnt/binaries

ENTRYPOINT ["/usr/local/bin/osslsigncode"]
