# docker-protoc

<a href="https://github.com/mkenney/software-guides/blob/master/STABILITY-BADGES.md#mature"><img src="https://img.shields.io/badge/stability-mature-008000.svg" alt="Mature"></a> This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html). This package is considered mature, you should expect package stability in <strong>Minor</strong> and <strong>Patch</strong> version releases.

- **Major**: backwards incompatible package updates
- **Minor**: feature additions, removal of deprecated features
- **Patch**: bug fixes, backward compatible model and function changes, etc.

**[CHANGELOG](CHANGELOG.md)**<br>

<a href="https://github.com/bdlm/docker-protoc/blob/master/CHANGELOG.md"><img src="https://img.shields.io/github/v/release/bdlm/docker-protoc" alt="Release"></a>
<a href="https://github.com/bdlm/docker-protoc/issues"><img src="https://img.shields.io/github/issues-raw/bdlm/docker-protoc.svg" alt="Github issues"></a>
<a href="https://github.com/bdlm/docker-protoc/pulls"><img src="https://img.shields.io/github/issues-pr/bdlm/docker-protoc.svg" alt="Github pull requests"></a>
<a href="https://github.com/bdlm/docker-protoc/blob/master/LICENSE"><img src="https://img.shields.io/github/license/bdlm/docker-protoc.svg?" alt="MIT"></a>

This image is used to compile protobuf API definitions into Golang gRPC and REST services using the [grpc-gateway](https://github.com/grpc-ecosystem/grpc-gateway) package.

## Available Packages

* github.com/envoyproxy/protoc-gen-validate
* github.com/golang/mock
* github.com/golang/protobuf
* github.com/golang/protobuf/protoc-gen-go
* github.com/grpc-ecosystem/grpc-gateway
* github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
* github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
* github.com/kisielk/errcheck
* github.com/shurcooL/vfsgen
* google.golang.org/grpc

## Examples
Examples of compiling the [service orchestration healthchecks](https://github.com/bdlm/api/tree/master/proto/v1/orchestration).

### Generate gRPC-Gateway packages with swagger docs
```
protoc \
	-I=${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
	-I=${GOPATH}/src/github.com/envoyproxy \
	-I=${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway \
	-I=${GOPATH}/src/github.com/bdlm/api/proto/v1/orchestration \
	-I=/usr/local/include \
	--go_opt=paths=source_relative \
	--go_out=plugins=grpc:${GOPATH}/src/github.com/bdlm/api/proto/v1/orchestration \
	--grpc-gateway_out=logtostderr=true:${GOPATH}/src/github.com/bdlm/api/proto/v1/orchestration \
	--validate_out=lang=go:${GOPATH}/src/github.com/bdlm/api/proto/v1/orchestration \
	--swagger_out=logtostderr=true,allow_merge=true,merge_file_name=external.swagger:${GOPATH}/src/github.com/bdlm/api/ \
	proto/v1/orchestration/swagger \
	${GOPATH}/src/github.com/bdlm/api/proto/v1/orchestration/response.proto
```

### Generate embedded docs with vfsgen
```
go run -mod=vendor \
	${GOPATH}/src/github.com/bdlm/docker-protoc/vfsgen.go \
	--dir=./orchestration/swagger/ \
	--outfile=./orchestration/docs/docs.go \
	--pkg=docs \
	--variable=Docs
```

### Generate service mocks
```
mockgen \
	--destination=./orchestration/mock/mock.go \
	github.com/bdlm/api/proto/v1/orchestration \
	OrchestrationClient,OrchestrationServer
```

