#!/bin/sh -x
protoc --version
exit_code=0
for dir in "$@"; do
    go generate -v -x --mod=vendor "$dir/..."
    e=$?; if [ "0" != "$e" ]; then
        exit_code=$e
    fi
done
exit $exit_code
