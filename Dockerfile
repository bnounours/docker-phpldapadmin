FROM dinkel/nginx-phpfpm:8.2

MAINTAINER Christian Luginbühl <dinkel@pimprecords.com>

ENV PHPLDAPADMIN_VERSION 1.2.2

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        phpldapadmin=${PHPLDAPADMIN_VERSION}* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN cd /usr/share/phpldapadmin && tar -chvzf /pla.tar.gz config templates queries hooks

COPY default.conf /etc/nginx/conf.d/

COPY www.conf /etc/php5/fpm/pool.d/

COPY bootstrap.sh /

ENTRYPOINT ["/bootstrap.sh"]

VOLUME ["/etc/phpldapadmin"]

# This script comes from the parent image
CMD ["/run.sh"]
