FROM alpine:3.21.3

ARG PHP_VERSION=83 \
    DB_NAME \
    DB_USER \
    DB_HOST \
    ADM_WP_NAME \
    ADM_WP_EMAIL \
    WP_USERNAME \
    WP_USEREMAIL \
    WP_TITLE \
    WP_HOST

ENV DB_NAME=$DB_NAME \
    DB_USER=$DB_USER \
    DB_HOST=$DB_HOST \
    ADM_WP_NAME=$ADM_WP_NAME \
    ADM_WP_EMAIL=$ADM_WP_EMAIL \
    WP_USERNAME=$WP_USERNAME \
    WP_USEREMAIL=$WP_USEREMAIL \
    WP_TITLE=$WP_TITLE \
    WP_HOST=$WP_HOST

RUN apk update && apk upgrade && apk add --no-cache \
    mariadb-client \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-phar \
    php-tokenizer \
    wget \
    unzip && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
      /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
      /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
      /etc/php${PHP_VERSION}/php-fpm.d/www.conf && \
    rm -f /var/cache/apk/*

RUN mkdir -p /usr/src/wordpress && \
    wget https://wordpress.org/wordpress-6.6.2.zip && \
    unzip wordpress-6.6.2.zip -d /usr/src && \
    rm wordpress-6.6.2.zip

RUN wget https://github.com/wp-cli/wp-cli/releases/download/v2.10.0/wp-cli-2.10.0.phar \
    && chmod +x wp-cli-2.10.0.phar && mv wp-cli-2.10.0.phar /usr/local/bin/wp

COPY requirements/wordpress/conf/startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

CMD ["/usr/local/bin/startup.sh"]
