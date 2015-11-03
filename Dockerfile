FROM ubuntu:trusty
MAINTAINER Josh Cox <josh 'at' webhosting.coop>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys E5267A6C; \
    echo 'deb http://ppa.launchpad.net/ondrej/php5/ubuntu trusty main' > /etc/apt/sources.list.d/ondrej-php5-trusty.list; \
    apt-get update ; \
    apt-get -y install nginx php5-fpm php5-mysql php-apc php5-imagick php5-imap php5-mcrypt php5-curl php5-cli php5-gd php5-pgsql php5-sqlite php5-common php-pear curl php5-json php5-redis redis-server memcached php5-memcache ; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ && mv /usr/bin/composer.phar /usr/bin/composer
RUN mkdir -p /srv/www
RUN echo "<?php phpinfo(); ?>" > /srv/www/phpinfo.php

ADD ./default /etc/nginx/sites-available/default

RUN apt-get update
RUN apt-get install -y apache2 libapache2-mod-php5 php5-mysql libapache2-mod-webauthldap
RUN a2enmod rewrite
RUN a2enmod expires
RUN a2enmod headers
RUN a2enmod remoteip
RUN a2enmod ldap

RUN  rm -rf /var/lib/apt/lists/*
ADD ./apache2.conf /etc/apache2/apache2.conf
ADD ./default.conf /etc/apache2/sites-available/000-default.conf
ADD ./security.conf /etc/apache2/conf-available/security.conf
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
RUN rm -f /var/www/index.html

ADD . /var/www

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]
