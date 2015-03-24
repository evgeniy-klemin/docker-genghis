FROM ubuntu:14.04
MAINTAINER Evgeniy Klemin <evgeniy.klemin@gmail.com>

#Setup container environment parameters
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

#==========================================================
#                        LOCALE
#==========================================================
RUN apt-get update && apt-get install -y \
        locales \
    && rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8


#==========================================================
#                          PHP
#==========================================================
RUN apt-get update && apt-get install -y \
        python-software-properties \
        software-properties-common \
        bash-completion \
    && rm -rf /var/lib/apt/lists/*
RUN echo "deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C
RUN apt-get update && apt-get install -y \
        php5-common \
        php5-cli \
        php5-fpm \
        php5-mongo \
    && rm -rf /var/lib/apt/lists/*


#==========================================================
#                         GENGHIS
#==========================================================
ADD https://raw.githubusercontent.com/bobthecow/genghis/v2.3.11/genghis.php /var/www/genghis/genghis.php
RUN chown www-data.www-data /var/www/genghis -R


#==========================================================
#                          NGINX
#==========================================================
RUN apt-get update && apt-get install -y \
        wget \
    && rm -rf /var/lib/apt/lists/*
RUN wget -O /tmp/nginx_signing.key http://nginx.org/keys/nginx_signing.key && \
    apt-key add /tmp/nginx_signing.key
RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
        ca-certificates \
        nginx \
    && rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]
ADD nginx.conf /etc/nginx/nginx.conf
ADD .htpasswd /etc/nginx/.htpasswd


CMD /etc/init.d/php5-fpm start && nginx
