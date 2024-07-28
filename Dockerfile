FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
		libfreetype-dev \
		libjpeg62-turbo-dev \
		libpng-dev locales \
        libicu-dev  \
        cron libzip-dev&&\
        docker-php-ext-install zip && \
        docker-php-ext-install mysqli && \
        docker-php-ext-configure intl && \
        docker-php-ext-install intl && \
        docker-php-ext-configure gd && \
        docker-php-ext-install -j$(nproc) gd && \
        docker-php-ext-enable gd

COPY moodle /var/www/html/

COPY docker /usr/docker

RUN chown -R www-data:www-data /var/www/html/ && \
    chmod 750 -R /var/www/html/ &&  \
    cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    echo '* * * * * root /usr/local/bin/php /var/www/html/admin/cli/cron.php >/var/log/moodle_cron.log 2>&1' >> /etc/cron.d/moodle-cron && \
    chmod 0644 /etc/cron.d/moodle-cron && \
    crontab /etc/cron.d/moodle-cron &&\
    chmod 770 /usr/docker/entrypoint.sh &&\
    { \
        echo 'log_errors = on'; \
        echo 'display_errors = off'; \
        echo 'always_populate_raw_post_data = -1'; \
        echo 'cgi.fix_pathinfo = 1'; \
        echo 'session.auto_start = 0'; \
        echo 'upload_max_filesize = 100M'; \
        echo 'post_max_size = 150M'; \
        echo 'max_execution_time = 1800'; \
        echo 'max_input_vars = 5000'; \
        echo '[opcache]'; \
        echo 'opcache.enable = 1'; \
        echo 'opcache.memory_consumption = 128'; \
        echo 'opcache.max_accelerated_files = 8000'; \
        echo 'opcache.revalidate_freq = 60'; \
        echo 'opcache.use_cwd = 1'; \
        echo 'opcache.validate_timestamps = 1'; \
        echo 'opcache.save_comments = 1'; \
        echo 'opcache.enable_file_override = 0'; \
    } | tee /usr/local/etc/php/php.ini && \
    export LANG=pt_BR.UTF-8 && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LAN=$LANG
    
EXPOSE 80 443

CMD ["/usr/docker/entrypoint.sh"]