FROM octohost/php5-apache
MAINTAINER Josh Cox <josh 'at' webhosting.coop>
ENV DEBIAN_FRONTEND noninteractive

ADD . /var/www

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]
