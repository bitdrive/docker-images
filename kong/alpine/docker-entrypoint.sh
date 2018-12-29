#!/bin/sh
set -e

export KONG_NGINX_DAEMON=off
if [[ "$1" == "kong" ]]; then
  PREFIX=${KONG_PREFIX:=/usr/local/kong}

  if [[ "$2" == "docker-start" ]]; then
    need_install_plugins=${KONG_PLUGINS:-}
    kong prepare -p "$PREFIX"
    if [ -n "$need_install_plugins" ];then
        echo "luarocks install kong-plugin-${need_install_plugins} --local"
        luarocks install kong-plugin-${need_install_plugins} --local
    fi
    exec /usr/local/openresty/nginx/sbin/nginx \
      -p "$PREFIX" \
      -c nginx.conf
  fi
fi

exec "$@"
