FROM php:7.1-fpm

ADD crontab /etc/cron.d/hello-cron

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y --force-yes apt-utils \
  && apt-get install -y --force-yes libssl-dev libmcrypt-dev libfreetype6-dev libjpeg62-turbo-dev libpng12-dev \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd mcrypt calendar exif gettext mysqli pcntl pdo_mysql shmop sockets sysvmsg sysvsem sysvshm zip \
  && pecl install mongodb && docker-php-ext-enable mongodb \
  && pecl install xdebug-beta && docker-php-ext-enable xdebug \
  && apt-get -y install cron && chmod 0644 /etc/cron.d/hello-cron && touch /var/log/cron.log

FROM node:4.3.2

RUN useradd --user-group --create-home --shell /bin/false app &&\
  npm install --global npm@3.7.5

CMD cron && tail -f /var/log/cron.log

ENV HOME=/home/app

USER app
WORKDIR $HOME/chat
