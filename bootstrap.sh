#!/bin/bash
set -e

if [ ! -L /usr/share/phpldapadmin/config ]; then
	rm -Rf /etc/phpldapadmin/*
	tar -xvzf /pla.tar.gz -C /etc/phpldapadmin
	rm -Rf /usr/share/phpldapadmin/config /usr/share/phpldapadmin/templates /usr/share/phpldapadmin/queries /usr/share/phpldapadmin/hooks
	ln -s /etc/phpldapadmin/config /usr/share/phpldapadmin/config
	ln -s /etc/phpldapadmin/templates /usr/share/phpldapadmin/templates
	ln -s /etc/phpldapadmin/queries /usr/share/phpldapadmin/queries
	ln -s /etc/phpldapadmin/hooks /usr/share/phpldapadmin/hooks
	mv /etc/phpldapadmin/config/config.php.example /etc/phpldapadmin/config/config.php
fi
 


LDAP_SERVER_HOST="${LDAP_SERVER_HOST:-openldap}"
LDAP_SERVER_PORT="${LDAP_SERVER_PORT:-389}"

UNIQUE_ATTRS="${UNIQUE_ATTRS:-mail,uid,uidNumber}"

sed -i "s/^\/\/ \(\$servers->setValue('server','host','\).*\(');\)$/\1$LDAP_SERVER_HOST\2/g" /etc/phpldapadmin/config/config.php
sed -i "s/^\/\/ \(\$servers->setValue('server','port',\).*\();\)$/\1$LDAP_SERVER_PORT\2/g" /etc/phpldapadmin/config/config.php

attr_string=""

IFS=","; declare -a attrs=($UNIQUE_ATTRS)

for attr in "${attrs[@]}"; do
    attr_string="$attr_string,'$attr'"
done

attr_string="${attr_string:1}"

sed -i "s/^#  \(\$servers->setValue('unique','attrs',\).*\();\)$/\1array($attr_string)\2/g" /etc/phpldapadmin/config/config.php

if [ "$1" = '/run.sh' ]; then
	exec /run.sh "$@"
fi

exec "$@"
