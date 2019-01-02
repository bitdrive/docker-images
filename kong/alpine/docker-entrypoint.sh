#!/bin/sh
set -e

export KONG_NGINX_DAEMON=off
if [[ "$1" == "kong" ]]; then
  PREFIX=${KONG_PREFIX:=/usr/local/kong}

  if [[ "$2" == "docker-start" ]]; then
    need_install_plugins=${KONG_PLUGINS:-}
    # 测试 need_install_plugins="bundled, ,bundled,, hello ,myplugin,bundled"
    need_install_plugins=${need_install_plugins//, /,}
    need_install_plugins=${need_install_plugins// ,/,}
    need_install_plugins=${need_install_plugins//,,/,}
    need_install_plugins=${need_install_plugins//,bundled,/,}
    need_install_plugins=${need_install_plugins//bundled,/}
    need_install_plugins=${need_install_plugins//,bundled/}
    
    kong prepare -p "$PREFIX"
    if [ -n "$need_install_plugins" ];then
        need_install_plugins="luarocks install kong-plugin-"${need_install_plugins//,/ --local && luarocks install kong-plugin-}" --local"
        echo "$need_install_plugins"
        echo "${need_install_plugins}" | awk '{cmd=$0; system(cmd)}'
    fi
    exec /usr/local/openresty/nginx/sbin/nginx \
      -p "$PREFIX" \
      -c nginx.conf
  fi
fi

exec "$@"
