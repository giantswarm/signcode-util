[![CircleCI](https://circleci.com/gh/giantswarm/signcode-util.svg?style=svg)](https://circleci.com/gh/giantswarm/signcode-util)
[![Docker Repository on Quay](https://quay.io/repository/giantswarm/signcode-util/status "Docker Repository on Quay")](https://quay.io/repository/giantswarm/signcode-util)

# signcode-util

A Docker container for [osslsigncode](https://sourceforge.net/projects/osslsigncode/files/osslsigncode/) to sign binaries for Windows.


## Usage

1. Place your key and certificate files in a local directory, e. g. `./test/certs`.
2. Place your binary to be signed in a local directory, e. g. `./test/binaries`.
3. Execute the command like this:

```nohighlight
docker run --rm -ti \
  -v $(pwd)/test/certs:/mnt/certs \
  -v $(pwd)/test/binaries:/mnt/binaries \
  quay.io/giantswarm/signcode-util:latest \
  sign \
  -certs /mnt/certs/cert.pem \
  -key /mnt/certs/key.pem \
  -h sha256 \
  -n "My Program Name" \
  -i https://example.com \
  -in /mnt/binaries/unsigned.exe \
  -out /mnt/binaries/signed.exe
```
