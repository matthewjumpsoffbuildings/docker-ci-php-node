FROM ubuntu:16.10

RUN export LC_ALL=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update
RUN apt-get install wget curl ssh rsync ssh openssh-client git build-essential apt-utils software-properties-common python-software-properties -y

# PHP
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update ; apt-get install -y --allow-unauthenticated \
    php7.1 \
    php7.1-curl \
    php7.1-gd \
    php7.1-dev \
    php7.1-xml \
    php7.1-bcmath \
    php7.1-mysql \
    php7.1-mbstring \
    php7.1-zip \
    php7.1-sqlite \
    php-xdebug
RUN command -v php

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer
RUN command -v composer

# PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit
RUN command -v phpunit

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_7.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs -y
RUN command -v node
RUN command -v npm

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

RUN command -v yarn

# Other
RUN mkdir ~/.ssh
RUN touch ~/.ssh_config

# Display versions installed
RUN php -v
RUN composer --version
RUN phpunit --version
RUN node -v
RUN npm -v
RUN yarn --version