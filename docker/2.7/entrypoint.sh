#!/usr/bin/env bash

if [ ! -d /data/itop ];then
  rsync -aqu /usr/src/itop/ /data/itop/
  mkdir -p /data/itop/{conf,data,log,env-production,env-production-build,env-test,env-test-build}
  chown -R www-data:www-data /data/itop/{conf,data,log,env-production,env-production-build,env-test,env-test-build}
fi

if [ ! -L /var/www/html ];then
  rm -rf /var/www/html
  ln -sf /data/itop /var/www/html
fi

exec $@
