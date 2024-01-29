[![CircleCI](https://dl.circleci.com/status-badge/img/gh/giantswarm/signcode-util/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/giantswarm/signcode-util/tree/main)

# signcode-util

A Docker image for [osslsigncode](https://github.com/mtrojnar/osslsigncode) to sign binaries for Windows.

## Usage

### Signing a binary

1. Place your PKCS#12 key store (.P12 file) in a local directory, e. g. `./certs/`.
2. Place your binary to be signed in a local directory, e. g. `./binaries/`.
3. Execute the command like this:

```nohighlight
docker run --rm -ti \
  -v $(pwd)/certs:/mnt/certs \
  -v $(pwd)/binaries:/mnt/binaries \
  gsoci.azurecr.io/giantswarm/signcode-util:latest \
  sign \
  -pkcs12 /mnt/certs/cert.p12 \
  -n "My Program Name" \
  -i https://example.com \
  -in /mnt/binaries/unsigned.exe \
  -out /mnt/binaries/signed.exe \
  -pass <pkcs12-file-password>
```

You should get `Succeeded` as the only output in case of success.

For syntax details, run `docker run --rm -ti quay.io/giantswarm/signcode-util:latest`.

### Verifying a signed binary

```nohighlight
docker run --rm -ti \
  -v $(pwd)/binaries:/mnt/binaries \
  gsoci.azurecr.io/giantswarm/signcode-util:latest \
  verify \
  /mnt/binaries/signed.exe
```

The output will look similar to this:

```nohighlight
Current PE checksum   : 00AC0656
Calculated PE checksum: 00AC0656

Message digest algorithm  : SHA1
Current message digest    : 05830C452810052993D51FBDC180FFCD3BA920DA
Calculated message digest : 05830C452810052993D51FBDC180FFCD3BA920DA

Signature verification: ok

Number of signers: 1
  Signer #0:
    Subject: /C=DE/postalCode=50670/ST=Nordrhein-Westfalen/L=Cologne/street=c/o Startplatz/street=Im Mediapark 5/O=Giant Swarm GmbH/CN=Giant Swarm GmbH
    Issuer : /C=US/O=SSL.com/OU=www.ssl.com/CN=SSL.com Object CA

Number of certificates: 3
  Cert #0:
    Subject: /C=DE/postalCode=50670/ST=Nordrhein-Westfalen/L=Cologne/street=c/o Startplatz/street=Im Mediapark 5/O=Giant Swarm GmbH/CN=Giant Swarm GmbH
    Issuer : /C=US/O=SSL.com/OU=www.ssl.com/CN=SSL.com Object CA
  Cert #1:
    Subject: /C=US/O=SSL.com/OU=www.ssl.com/CN=SSL.com Object CA
    Issuer : /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
  Cert #2:
    Subject: /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority
    Issuer : /C=US/ST=New Jersey/L=Jersey City/O=The USERTRUST Network/CN=USERTrust RSA Certification Authority

Succeeded
```
