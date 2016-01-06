# A container for testing libinjection
FROM golang:1.5.2-alpine
MAINTAINER https://github.com/client9/libinjection-docker
RUN apk update
RUN apk upgrade
RUN apk add musl-dev gcc clang make git python
RUN apk -vv info|sort
