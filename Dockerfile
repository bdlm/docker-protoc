########################################################################
# protobuff go compiler
########################################################################
FROM golang:1.14.1-buster

# System setup
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm \
    TIMEZONE=UTC \
    PATH=$PATH:/usr/local/bin

RUN set -eux; \
    # System software
    apt-get -qqy update; \
    apt-get -qqy upgrade; \
    curl -sL https://deb.nodesource.com/setup_12.x | bash -; \
    apt-get -qqy --no-install-recommends install \
        autoconf \
        automake \
        build-essential \
        ca-certificates \
        gnupg \
        libcap2-bin \
        libtool \
        nodejs \
        pkg-config \
        tzdata \
        wget \
        unzip; \
    npm_config_user=root npm install -g --save \
        google-protobuf \
        ts-protoc-gen; \
    # Timezone config
    echo $TIMEZONE > /etc/timezone; \
    DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure --frontend noninteractive tzdata; \
    # Clean up tmp and setup files
    rm -rf \
        /tmp/* \
        /tmp/.build \
        /var/tmp/* \
        /var/lib/apt/lists/* \
        /var/cache/apt/*;

# PHP protobuf requirements
RUN set -eux; \
    mkdir -p /go/src/github.com; \
    cd /go/src/github.com; \
    git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc; \
    cd grpc; \
    git submodule update --init --recursive; \
    make grpc_php_plugin; \
    make; \
    make install; \
    cd /go/src/github.com/grpc/third_party/protobuf; \
    make install

# Golang protobuf and other requirements
RUN set -eux; \
    # Google well-known-type protobuf definitions
    wget -O /tmp/protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_64.zip"; \
    unzip /tmp/protoc.zip -d /tmp/; \
    cp -ravp /tmp/include/ /usr/local/; \
    cp -ravp /tmp/bin/ /usr/; \
    # Common golang modules/packages used on go generate statements
    go get -u github.com/grpc-ecosystem/grpc-gateway/...; \
    go get -u github.com/envoyproxy/protoc-gen-validate; \
    go get -u google.golang.org/grpc; \
    go get -u github.com/golang/mock/...; \
    go get -u github.com/shurcooL/vfsgen; \
    go build -i -o "$(go env GOPATH)"/bin/cover cmd/cover; \
    go get -u github.com/kisielk/errcheck; \
    go get -d -u github.com/golang/protobuf/...; \
    git -C "$(go env GOPATH)"/src/github.com/golang/protobuf checkout "v1.3.5"; \
    go install github.com/golang/protobuf/protoc-gen-go;

COPY ./vfsgen.go /go/src/github.com/bdlm/docker-protoc/
COPY ./entrypoint.sh /go/src/github.com/docker-protoc/

WORKDIR /src

ENTRYPOINT ["/go/src/github.com/docker-protoc/entrypoint.sh"]
