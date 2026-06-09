#!/usr/bin/env bash

if [ ! -d /data/itop ];then
  rsync -aqu /usr/src/itop/ /data/itop/
  mkdir -p /data/itop/{conf,data,log,env-production,env-production-build}
  chown -R www-data:www-data /data/itop/{conf,data,log,env-production,env-production-build}
  find /data/itop -type d -exec chmod 755 {} \;
  find /data/itop -type f -exec chmod 644 {} \;
fi

if [ ! -L /var/www/html ];then
  rm -rf /var/www/html
  ln -sf /data/itop /var/www/html
fi

if [ $1 != "apache2ctl" ];then
  exec $@
else
  install -d -m 755 -o www-data -g www-data /var/run/apache2 
  exec gosu www-data:www-data "$@"
fi
