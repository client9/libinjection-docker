# A container for testing libinjection
FROM alpine:3.3
#golang:1.5.2-alpine
MAINTAINER https://github.com/client9/libinjection-docker

# basics needed for libinjection:
#
# Requirements:
#  musl-dev - standard c headers
#  gcc      - a C compiler
#  make     - used to make some rules although this could be eliminated
#  python   - used to generate some files
#
# Option items used for testing:
#  clang     - Another C compiler and for static analyzer
#  valgrind  - memory checking
#
RUN apk add --update musl-dev gcc make python clang valgrind

# cppcheck - https://github.com/danmar/cppcheck
# alpine linux requires -DNO_UNIX_SIGNAL_HANDLING
# something is defining GNUC and causing issues, this
# chops out that code.  Only used in CLI
#
# prce-dev needs to stick around, although I suspect we could optimize
# since its composed of the follow.  Doubt we need all of them.
#   * Installing libpcre16 (8.38-r0)
#   * Installing libpcre32 (8.38-r0)
#   * Installing pcre (8.38-r0)
#
ADD https://github.com/danmar/cppcheck/archive/1.72.tar.gz cppcheck-1.72.tar.gz
RUN apk add libc-dev g++ pcre-dev \
    && tar -xzf cppcheck-1.72.tar.gz \
    && cd cppcheck-1.72 \
    && g++ -DNO_UNIX_SIGNAL_HANDLING -DHAVE_RULES \
           -DCFGDIR=\"/usr/share/cppcheck/cfg/\" \
           -o cppcheck -std=c++0x \
           -include lib/cxx11emu.h -lpcre -Ilib -Iexternals/tinyxml \
           cli/*.cpp lib/*.cpp externals/tinyxml/*.cpp \
    && mkdir -p /usr/share/cppcheck/ \
    && mv cfg /usr/share/cppcheck/cfg \
    && mv cppcheck /usr/bin \
    && rm -rf cppcheck* \
    && apk del libc-dev g++ \
    && rm -f /var/cache/apk/*
