FROM alpine:latest
MAINTAINER Ingmar Delsink https://github.com/idelsink
label version="2.0.0" \
      description="Ampache docker image with Linux Alpine"

# Apache
ENV APACHE_WEB_ROOT=/var/www/localhost \
    APACHE_PID_FILE=/run/apache2/httpd.pid \
    APACHE_USER=apache \
    APACHE_GROUP=www-data

# Ampache
ENV AMPACHE_VER=5.5.3 \
    AMPACHE_WEB_DIR=${APACHE_WEB_ROOT}/ampache

# MySQL
ENV MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_SOCKET=/var/run/mysqld/mysqld.sock \
    MYSQL_PID_FILE=/var/run/mysqld/mysqld.pid \
    MYSQL_PORT=3306 \
    MYSQL_USER=mysql
    
RUN apk --no-cache update && \
    apk add --no-cache \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
    php7-openssl

# update, upgrade and install:
RUN apk --no-cache update && \
    apk add --no-cache \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
        apache2 \
        apache2-utils \
        apache2-webdav \
        ffmpeg \
        file \
        git \
        mysql \
        mysql-client \
        php7 \
        php7-apache2 \
        php7-curl \
        php7-dom \
        php7-gd \
        php7-gettext \
        php7-iconv \
        php7-json \
       # php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-phar \
        php7-sockets \
        php7-xml \
        php7-xmlreader \
        php7-zlib \
        pwgen \
        supervisor \
        wget
        


WORKDIR /

ADD root \
    https://github.com/ampache/ampache/archive/${AMPACHE_VER}.zip \
    # ampache-${AMPACHE_VER}.zip \
    /

RUN /scripts/configure.sh

#    80: http
#   443: https (for future setup)
#  9001: supervisord web
# 32400: plex
EXPOSE 80 443 9001 32400

ENTRYPOINT [ "/scripts/entrypoint.sh" ]
