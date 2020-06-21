########################################################################
# protobuff go compiler
########################################################################
FROM golang:1.14.1-buster

# System setup
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm \
    TIMEZONE=UTC \
    PATH=$PATH:/usr/local/bin

RUN set -eux \
    # System software
    && apt-get -qqy update \
    && apt-get -qqy upgrade \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get -qqy --no-install-recommends install \
        autoconf \
        automake \
        build-essential \
        ca-certificates \
        gnupg \
        libcap2-bin \
        libprotobuf-dev \
        libtool \
        nodejs \
        pkg-config \
        tzdata \
        wget \
        unzip \
    && npm_config_user=root npm install -g --save \
        google-protobuf \
        ts-protoc-gen \
    # Timezone config
    && echo $TIMEZONE > /etc/timezone \
    && DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure --frontend noninteractive tzdata \
    # Clean up tmp and setup files
    && rm -rf \
        /tmp/* \
        /tmp/.build \
        /var/tmp/* \
        /var/lib/apt/lists/* \
        /var/cache/apt/*

# Golang protobuf and other requirements
RUN set -eux \
    # Google well-known-type protobuf definitions
    && wget -O /tmp/protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v3.12.1/protoc-3.12.1-linux-x86_64.zip" \
    && unzip /tmp/protoc.zip -d /tmp/ \
    && cp -ravp /tmp/include/ /usr/local/ \
    && cp -ravp /tmp/bin/ /usr/ \
    && cd /usr/local/include \
    && git clone https://github.com/googleapis/googleapis.git \
    && mkdir -p google \
    && mv googleapis/google/* google/ \
    && rm -rf googleapis/ \
    # Common golang modules/packages used with go generate statements
    && go get -u github.com/grpc-ecosystem/grpc-gateway/... \
    && go get -u github.com/envoyproxy/protoc-gen-validate \
    && go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
    && go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
    && go get -u github.com/golang/protobuf/protoc-gen-go \
    && go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
    && go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
    && go install github.com/golang/protobuf/protoc-gen-go \
    && go get -u google.golang.org/grpc \
    && go get -u github.com/golang/mock/... \
    && go get -u github.com/shurcooL/vfsgen \
    && go build -i -o "$(go env GOPATH)"/bin/cover cmd/cover \
    && go get -u github.com/kisielk/errcheck \
    && go get -d -u github.com/golang/protobuf/... \
    && git -C "$(go env GOPATH)"/src/github.com/golang/protobuf checkout "v1.4.2" \
    && go install github.com/golang/protobuf/protoc-gen-go;

WORKDIR ${GOPATH}/src/github.com/bdlm/docker-protoc/
COPY ./vfsgen.go .
COPY ./entrypoint.sh .
RUN go install

WORKDIR ${GOPATH}/src

ENTRYPOINT ["/go/src/github.com/bdlm/docker-protoc/entrypoint.sh"]
