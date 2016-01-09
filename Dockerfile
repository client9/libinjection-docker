# A container for testing libinjection
FROM golang:1.5.2-alpine
MAINTAINER https://github.com/client9/libinjection-docker
RUN apk update && apk upgrade && apk add musl-dev gcc clang make git python

