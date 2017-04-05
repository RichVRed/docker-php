# BUILD:
# docker build --force-rm --tag "rvannauker/php" --file php.dockerfile .
# RUN:
# docker run --rm --volume $(pwd):/workspace --name="php" "rvannauker/php" {destination}
# PACKAGE: PHP
# PACKAGE REPOSITORY: http://git.php.net/repository/php-src.git
# PACKAGE REPOSITORY MIRROR: https://github.com/php/php-src.git
# RELEASES: http://php.net/downloads.php
# BUILD RAW: http://php.net/git.php
# DESCRIPTION: PHP for PHP code
FROM alpine:latest
MAINTAINER Richard Vannauker <richard.vannauker@gmail.com>
# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL     org.label-schema.schema-version="1.0" \
          org.label-schema.build-date="$BUILD_DATE" \
          org.label-schema.version="$VERSION" \
          org.label-schema.name="" \
          org.label-schema.description="" \
          org.label-schema.vendor="SEOHEAT LLC" \
          org.label-schema.url="" \
          org.label-schema.vcs-ref="$VCS_REF" \
          org.label-schema.vcs-url="" \
          org.label-schema.usage="" \
          org.label-schema.docker.cmd="" \
          org.label-schema.docker.cmd.devel="" \
          org.label-schema.docker.cmd.test="" \
          org.label-schema.docker.cmd.debug="" \
          org.label-schema.docker.cmd.help="" \
          org.label-schema.docker.params="" \
          org.label-schema.rkt.cmd="" \
          org.label-schema.rkt.cmd.devel="" \
          org.label-schema.rkt.cmd.test="" \
          org.label-schema.rkt.cmd.debug="" \
          org.label-schema.rkt.cmd.help="" \
          org.label-schema.rkt.params="" \
          com.amazonaws.ecs.task-arn="" \
          com.amazonaws.ecs.container-name="" \
          com.amazonaws.ecs.task-definition-family="" \
          com.amazonaws.ecs.task-definition-version="" \
          com.amazonaws.ecs.cluster=""

# Install PHP from source
#### Dependencies:
#    autoconf:
#        2.59+
#    automake:
#        1.4+
#    libtool: ftp://ftp.gnu.org/pub/gnu/libtool/
#        1.4.x+ (except 1.4.2)
#    re2c:
#        0.13.4+
#    bison: ftp://ftp.gnu.org/pub/gnu/bison/
#        PHP 5.4: 1.28, 1.35, 1.75, 2.0 to 2.6.4
#        PHP 5.5: 2.4 to 2.7
#        PHP 5.6: 2.4 to 2.7
#        PHP 7:   2.4+
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
           curl \
           g++ \
           git \
           gnupg \
           make \
           perl \
    && echo 'Installing GNU Keyring' \
    && curl -sL ftp://ftp.gnu.org/gnu/gnu-keyring.gpg -o gnu-keyring.gpg \
    && echo 'Installing: M4 (PHP dependency)' \
    && curl -sL ftp://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz -o m4-1.4.18.tar.gz \
    && curl -sL ftp://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz.sig -o m4-1.4.18.tar.gz.sig \
    && out=$(gpg --status-fd 1 --verify --keyring ./gnu-keyring.gpg ./m4-1.4.18.tar.gz.sig 2>/dev/null) \
    && if echo "$out" | grep -qs "\[GNUPG:\] GOODSIG" && echo "$out" | grep -qs "\[GNUPG:\] VALIDSIG"; then echo "Good signature on m4 source."; else echo "GPG VERIFICATION OF M4 SOURCE FAILED!" && echo "EXITING!" && exit 100; fi \
    && tar -xvzf m4-1.4.18.tar.gz \
    && cd m4-1.4.18 \
    && ./configure --prefix=/usr/local/m4 \
    && make \
    && make install \
    && cd - \
    && ln -s /usr/local/m4/bin/m4 /usr/bin/m4 \
    && rm -rf m4-1.4.18 \
    && rm m4-1.4.18.tar.gz \
    && rm m4-1.4.18.tar.gz.sig \
    && echo 'Installing: AutoConf (PHP dependency)' \
    && curl -sL ftp://ftp.gnu.org/pub/gnu/autoconf/autoconf-2.69.tar.gz -o autoconf-2.69.tar.gz \
    && curl -sL ftp://ftp.gnu.org/pub/gnu/autoconf/autoconf-2.69.tar.gz.sig -o autoconf-2.69.tar.gz.sig \
    && out=$(gpg --status-fd 1 --verify --keyring ./gnu-keyring.gpg ./autoconf-2.69.tar.gz.sig 2>/dev/null) \
    && if echo "$out" | grep -qs "\[GNUPG:\] GOODSIG" && echo "$out" | grep -qs "\[GNUPG:\] VALIDSIG"; then echo "Good signature on autoconf source."; else echo "GPG VERIFICATION OF AUTOCONF SOURCE FAILED!" && echo "EXITING!" && exit 100; fi \
    && tar -xvzf autoconf-2.69.tar.gz \
    && cd autoconf-2.69 \
    && ./configure --prefix=/usr/local/autoconf \
    && make \
    && make install \
    && cd - \
    && ln -s /usr/local/autoconf/bin/autoconf /usr/bin/autoconf \
    && rm -rf autoconf-2.69 \
    && rm autoconf-2.69.tar.gz \
    && rm autoconf-2.69.tar.gz.sig \
    && echo 'Installing: AutoMake (PHP dependency)' \
    && curl -sL ftp://ftp.gnu.org/pub/gnu/automake/automake-1.15.tar.gz -o automake-1.15.tar.gz \
    && curl -sL ftp://ftp.gnu.org/pub/gnu/automake/automake-1.15.tar.gz.sig -o automake-1.15.tar.gz.sig \
    && out=$(gpg --status-fd 1 --verify --keyring ./gnu-keyring.gpg ./automake-1.15.tar.gz.sig 2>/dev/null) \
    && if echo "$out" | grep -qs "\[GNUPG:\] GOODSIG" && echo "$out" | grep -qs "\[GNUPG:\] VALIDSIG"; then echo "Good signature on automake source."; else echo "GPG VERIFICATION OF AUTOMAKE SOURCE FAILED!" && echo "EXITING!" && exit 100; fi \
    && tar -xvzf automake-1.15.tar.gz \
    && cd automake-1.15 \
    && ./configure --prefix=/usr/local/automake \
    && make \
    && make install \
    && cd - \
    && ln -s /usr/local/automake/bin/automake /usr/bin/automake \
    && rm -rf automake-1.15 \
    && rm automake-1.15.tar.gz \
    && rm automake-1.15.tar.gz.sig \
    && echo 'Installing: Bison (PHP dependency)' \
    && curl -sL ftp://ftp.gnu.org/pub/gnu/bison/bison-3.0.4.tar.gz -o bison-3.0.4.tar.gz \
    && curl -sL ftp://ftp.gnu.org/pub/gnu/bison/bison-3.0.4.tar.gz.sig -o bison-3.0.4.tar.gz.sig \
    && out=$(gpg --status-fd 1 --verify --keyring ./gnu-keyring.gpg ./bison-3.0.4.tar.gz.sig 2>/dev/null) \
    && if echo "$out" | grep -qs "\[GNUPG:\] GOODSIG" && echo "$out" | grep -qs "\[GNUPG:\] VALIDSIG"; then echo "Good signature on bison source."; else echo "GPG VERIFICATION OF BISON SOURCE FAILED!" && echo "EXITING!" && exit 100; fi \
    && tar -xvzf bison-3.0.4.tar.gz \
    && cd bison-3.0.4 \
    && ./configure --prefix=/usr/local/bison --with-libiconv-prefix=/usr/local/libiconv/ \
    && make \
    && make install \
    && cd - \
    && ln -s /usr/local/bison/bin/bison /usr/bin/bison \
    && ln -s /usr/local/bison/bin/yacc /usr/bin/yacc \
    && rm -rf bison-3.0.4 \
    && rm bison-3.0.4.tar.gz \
    && rm bison-3.0.4.tar.gz.sig \
    && echo 'Installing: Libtool (PHP dependency)' \
    && curl -sL ftp://ftp.gnu.org/pub/gnu/libtool/libtool-2.4.6.tar.gz -o libtool-2.4.6.tar.gz \
    && curl -sL ftp://ftp.gnu.org/pub/gnu/libtool/libtool-2.4.6.tar.gz.sig -o libtool-2.4.6.tar.gz.sig \
    && out=$(gpg --status-fd 1 --verify --keyring ./gnu-keyring.gpg ./libtool-2.4.6.tar.gz.sig 2>/dev/null) \
    && if echo "$out" | grep -qs "\[GNUPG:\] GOODSIG" && echo "$out" | grep -qs "\[GNUPG:\] VALIDSIG"; then echo "Good signature on libtool source."; else echo "GPG VERIFICATION OF LIBTOOL SOURCE FAILED!" && echo "EXITING!" && exit 100; fi \
    && tar -xvzf libtool-2.4.6.tar.gz \
    && cd libtool-2.4.6 \
    && ./configure --prefix=/usr/local/libtool --disable-debug \
    && make \
    && make install \
    && cd - \
    && ln -s /usr/local/libtool/bin/libtool /usr/bin/libtool \
    && rm -rf libtool-2.4.6 \
    && rm libtool-2.4.6.tar.gz \
    && rm libtool-2.4.6.tar.gz.sig \
    && rm gnu-keyring.gpg \
    && echo 'Installing: re2c (PHP dependency)' \
    && curl -sL https://github.com/skvadrik/re2c/releases/download/0.16/re2c-0.16.tar.gz -o re2c-0.16.tar.gz \
    && tar -xvzf re2c-0.16.tar.gz \
    && cd re2c-0.16 \
    && ./configure --prefix=/usr/local/re2c \
    && make \
    && make install \
    && cd - \
    && ln -s /usr/local/re2c/bin/re2c /usr/bin/re2c \
    && rm -rf re2c-0.16 \
    && rm re2c-0.16.tar.gz \
    && echo 'Installing: PHP 7.1 (from source)' \
    && git clone https://github.com/php/php-src.git \
    && cd php-src \
    && git checkout PHP-7.1 \
    && ./buildconf \
    && apk del curl g++ git gnupg make perl \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

# autoconf
# ftp://ftp.gnu.org/pub/gnu/autoconf/autoconf-2.69.tar.gz
# ftp://ftp.gnu.org/pub/gnu/autoconf/autoconf-2.69.tar.gz.sig

# automake
# ftp://ftp.gnu.org/pub/gnu/automake/automake-1.15.tar.gz
# ftp://ftp.gnu.org/pub/gnu/automake/automake-1.15.tar.gz.sig

# bison
# ftp://ftp.gnu.org/pub/gnu/bison/bison-3.0.4.tar.gz
# ftp://ftp.gnu.org/pub/gnu/bison/bison-3.0.4.tar.gz.sig

# libtool
# ftp://ftp.gnu.org/pub/gnu/libtool/libtool-2.4.6.tar.gz
# ftp://ftp.gnu.org/pub/gnu/libtool/libtool-2.4.6.tar.gz.sig

# re2c
# https://github.com/skvadrik/re2c/releases/download/0.16/re2c-0.16.tar.gz

ENTRYPOINT ["php"]