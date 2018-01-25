FROM ubuntu:xenial

MAINTAINER Balázs Soltész <solazs@sztaki.hu>

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get -y --no-install-recommends install apache2 libapache2-mod-shib2 openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable apache modules, generate dummy keys to ensure shibboleth can start,
# then redirect logs to STDOUT.
RUN a2enmod shib2 proxy_fcgi \
    && cd /etc/shibboleth/ && shib-keygen \
    && ln -sf /proc/self/fd/1 /var/log/apache2/access.log \
    && ln -sf /proc/self/fd/1 /var/log/apache2/error.log \
    && ln -sf /proc/self/fd/1 /var/log/shibboleth/shibd.log \
    && ln -sf /proc/self/fd/1 /var/log/shibboleth/shibd_warn.log \
    && ln -sf /proc/self/fd/1 /var/log/shibboleth/signature.log \
    && ln -sf /proc/self/fd/1 /var/log/shibboleth/transaction.log
    
VOLUME /etc/shibboleth /etc/apache2/sites-enabled /var/www

COPY ./httpd-shibd-foreground /usr/local/bin/
CMD [ "httpd-shibd-foreground" ]

EXPOSE 80 443
