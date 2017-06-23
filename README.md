[![CircleCI](https://circleci.com/gh/giantswarm/signcode-util.svg?style=svg)](https://circleci.com/gh/giantswarm/signcode-util)
[![Docker Repository on Quay](https://quay.io/repository/giantswarm/signcode-util/status "Docker Repository on Quay")](https://quay.io/repository/giantswarm/signcode-util)

# signcode-util

A utility to sign binaries for Windows. Meant to be run in a Docker container.

It is written in JavaScript and uses the https://github.com/kevinsawicki/signcode library.

## Usage

1. Place your key and certificate files in a local directory, e. g. `/path/to/certs`.
2. Place your binary to be signed in a local directory, e. g. `/path/to/binaries`.
3. Execute the command like this:

```nohighlight
docker run --rm -ti \
  -v /path/to/certs:/mnt/certs \
  -v /path/to/binaries:/mnt/binaries \
  quay.io/giantswarm/signcode-util \
  -c /mnt/certs/certificate.pem \
  -k /mnt/certs/privatekey.pem \
  -n "My Program Name" \
  -s "https://example.com" \
  /mnt/binaries/unsigned.exe \
  /mnt/binaries/signed.exe
```

### Full usage reference

```nohighlight
Usage: signcode-util [options] <exe_path> <signed_exe_path>

Options:

  -h, --help              output usage information
  -c, --cert <cert_path>  Certificate path
  -k, --key <key_path>    Private key path
  -n, --name <name>       A name/title for the executable
  -s, --site <site>       A website URL
```
