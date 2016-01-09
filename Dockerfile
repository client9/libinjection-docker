# A container for testing libinjection
FROM golang:1.5.2-alpine
MAINTAINER https://github.com/client9/libinjection-docker

# basics needed for libinjection:
#
#  musl-dev -  c headers
#  gcc a compiler
#  make
#  python is used to generate some files
#  git -- not sure why
#
#  clang is used as double-check and for static analyzer
#
RUN apk update && apk upgrade && apk add musl-dev gcc clang make git python

# cppcheck - https://github.com/danmar/cppcheck
# alpine linux requires -DNO_UNIX_SIGNAL_HANDLING
# something is defining GNUC and causing issues, this
# chops out that code.  Only used in CLI
#
ADD https://github.com/danmar/cppcheck/archive/1.71.tar.gz cppcheck-1.71.tar.gz
RUN apk add libc-dev g++ pcre-dev \
    && tar -xzf cppcheck-1.71.tar.gz \
    && cd cppcheck-1.71 \
    && g++ -DNO_UNIX_SIGNAL_HANDLING -DHAVE_RULES \
           -DCFGDIR=\"/usr/share/cppcheck/\" \
           -o cppcheck -std=c++0x \
           -include lib/cxx11emu.h -lpcre -Ilib -Iexternals/tinyxml \
           cli/*.cpp lib/*.cpp externals/tinyxml/*.cpp \
    && mkdir -p /usr/share/cppcheck/ \
    && cp cfg/* /usr/share/cppcheck/ \
    && mv cppcheck /usr/bin \
    && rm -rf cppcheck* \
    && apk del libc-dev g++ pcre-dev
