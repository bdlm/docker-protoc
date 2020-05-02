All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

# v3.1 - 2020-04-14
#### Added
- vfsgen.go which can be used for vfs generation

#### Changed
- n/a

#### Removed
- n/a

# v3.0 - 2020-03-31
#### Added
- Support for Go Modules

#### Changed
- Updated to Debian Buster.
- Updated from Golang 1.11 to 1.14.1
- Updated from Node 11.x to Node 12.x
- Updated to Golang Protobuf v1.3.5
- Updated Google Well-Known-Type protobufs to v3.11.4
- Updated Go packages.
- Updated Dockerfile format to match official docker hub format.

#### Removed
- Removed bashrc aliases.
- Removed Docker volume.


# v2.0 - 2020-03-13
#### Added
- n/a

#### Changed
- Updated Go packages.

**WARNING**: This version is not compatable with `api-infrastructure` v1.2.24 or older. The updated protoc package is not compatible with older versions of `grpc-gateway`.

#### Removed
- n/a


# v1.0 - 2019-02-12
#### Added
- Created an initial ECR image.

#### Changed
- n/a

#### Removed
- n/a
