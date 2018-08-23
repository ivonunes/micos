FROM alpine:3.7

RUN apk -U add wget bc build-base gawk xorriso libelf-dev openssl-dev bison flex syslinux
RUN apk -U add linux-headers perl
RUN apk -U add musl-dev
RUN apk -U add rsync git
RUN apk -U add argp-standalone

COPY ./src /build

WORKDIR /build

ENTRYPOINT ["./build.sh"]
CMD [""]
