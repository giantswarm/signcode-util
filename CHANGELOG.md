# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Use base images from `gsoci.azurecr.io`.

## [1.1.2] - 2023-09-29

- Upate Alpine base image

## [1.1.1] - 2022-04-13

- Upate Alpine base Docker image to v3.15.4

## [1.1.0] - 2022-04-13

- Update osslsigncode from v2.1 to v2.3
- Update Alpine base Docker image to v3.15.3

## [1.0.0] - 2021-05-18

### Changed

- Use upstream source [mtrojnar/osslsigncode](https://github.com/mtrojnar/osslsigncode) instead of the old SourceForge project, which no longer exists.
- Update CI configuration and use architect-orb.
- Improve Dockerfile for smaller resulting image and a simpler build.

[Unreleased]: https://github.com/giantswarm/signcode-util/compare/v1.1.2...HEAD
[1.1.2]: https://github.com/giantswarm/signcode-util/compare/v1.1.1...v1.1.2
[1.1.1]: https://github.com/giantswarm/signcode-util/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/giantswarm/signcode-util/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/giantswarm/signcode-util/releases/tag/v1.0.0
