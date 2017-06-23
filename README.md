[![CircleCI](https://circleci.com/gh/giantswarm/signcode-util.svg?style=svg)](https://circleci.com/gh/giantswarm/signcode-util)
[![Docker Repository on Quay](https://quay.io/repository/giantswarm/signcode-util/status "Docker Repository on Quay")](https://quay.io/repository/giantswarm/signcode-util)

# signcode-util

A Docker container for [osslsigncode](https://sourceforge.net/projects/osslsigncode/files/osslsigncode/) to sign binaries for Windows.


## Usage

### Signing a binary

1. Place your key and certificate files in a local directory, e. g. `./test/certs`.
2. Place your binary to be signed in a local directory, e. g. `./test/binaries`.
3. Execute the command like this:

```nohighlight
docker run --rm -ti \
  -v $(pwd)/test/certs:/mnt/certs -v $(pwd)/test/binaries:/mnt/binaries \
  quay.io/giantswarm/signcode-util:latest \
  sign \
  -certs /mnt/certs/cert.pem -key /mnt/certs/key.pem \
  -h sha256 \
  -n "My Program Name" \
  -i https://example.com \
  -in /mnt/binaries/unsigned.exe \
  -out /mnt/binaries/signed.exe
```

You should get `Succeeded` as the only output in case of success.

For syntax details, run `docker run --rm -ti quay.io/giantswarm/signcode-util:latest`.

### Verifying a signed binary

```nohighlight
docker run --rm -ti \
  -v $(pwd)/test/binaries:/mnt/binaries \
  quay.io/giantswarm/signcode-util:latest \
  verify \
  /mnt/binaries/signed.exe
```

The output will look like this:

```
Current PE checksum   : 00AADAE6
Calculated PE checksum: 00AADAE6

Message digest algorithm  : SHA256
Current message digest    : D7336D4FC09CC74A9C79E456AE5F3021B5E80911D86E79A7F50860E2DEF054A0
Calculated message digest : D7336D4FC09CC74A9C79E456AE5F3021B5E80911D86E79A7F50860E2DEF054A0

Signature verification: ok

Number of signers: 1
	Signer #0:
		Subject: /C=DE/ST=Nordrhein-Westfalen/L=Koeln/O=Giant Swarm GmbH/OU=Test Department/CN=example.com/emailAddress=support@giantswarm.io
		Issuer : /C=DE/ST=Nordrhein-Westfalen/L=Koeln/O=Giant Swarm GmbH/OU=Test Department/CN=example.com/emailAddress=support@giantswarm.io

Number of certificates: 1
	Cert #0:
		Subject: /C=DE/ST=Nordrhein-Westfalen/L=Koeln/O=Giant Swarm GmbH/OU=Test Department/CN=example.com/emailAddress=support@giantswarm.io
		Issuer : /C=DE/ST=Nordrhein-Westfalen/L=Koeln/O=Giant Swarm GmbH/OU=Test Department/CN=example.com/emailAddress=support@giantswarm.io

Succeeded
```
