FROM ubuntu:bionic

MAINTAINER Balázs Soltész <solazs@sztaki.hu>

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get -y --no-install-recommends install software-properties-common \
    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2 \
    && apt-get update \
    && apt install -y --no-install-recommends openssl curl gpg-agent \
    && curl -O http://pkg.switch.ch/switchaai/SWITCHaai-swdistrib.asc \
    && echo '67f733e2cdb248e96275546146ea2997b6d0c0575c9a37cb66e00d6012a51f68 SWITCHaai-swdistrib.asc' | sha256sum --check \
    && echo $fingerprint \
    && apt-key add SWITCHaai-swdistrib.asc \
    && apt purge -y --autoremove software-properties-common curl gpg-agent \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo 'deb http://pkg.switch.ch/switchaai/ubuntu bionic main' > /etc/apt/sources.list.d/SWITCHaai-swdistrib.list \
    && apt-get update \
    && apt-get install --install-recommends -y apache2 shibboleth \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./logformats.conf /etc/apache2/conf-enabled/

# Generate dummy keys to ensure shibboleth can start,
# then redirect logs to STDOUT.
RUN cd /etc/shibboleth/ && shib-keygen \
    && ln -sf /proc/self/fd/2 /var/log/apache2/access.log \
    && ln -sf /proc/self/fd/2 /var/log/apache2/error.log \
    && ln -sf /proc/self/fd/2 /var/log/shibboleth/shibd.log \
    && ln -sf /proc/self/fd/2 /var/log/shibboleth/shibd_warn.log \
    && ln -sf /proc/self/fd/2 /var/log/shibboleth/signature.log \
    && ln -sf /proc/self/fd/2 /var/log/shibboleth/transaction.log \
    && ln -sf /proc/self/fd/2 /var/log/apache2/other_vhosts_access.log

VOLUME /etc/shibboleth /etc/apache2/sites-enabled /var/www

COPY ./httpd-shibd-foreground /usr/local/bin/
CMD [ "httpd-shibd-foreground" ]

EXPOSE 80 443
