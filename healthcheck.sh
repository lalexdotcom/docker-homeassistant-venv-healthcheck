#!/bin/bash

HA_PROTOCOL="http"
HA_HOST="localhost"
HA_PORT="8123";

CONFIG_PATH=/config/configuration.yaml

echo "READ $CONFIG_PATH 'http' config key"

IFS= readarray -t -d '' config < <(shyaml key-values-0 http < $CONFIG_PATH)


key=
for line in ${config[@]}
do
  if [ -z $key ]; then
    key=$line
  else
    case $key in
      ssl_key)
        HA_PROTOCOL="https"
        ;;
      server_port)
        HA_PORT=$line
        ;;
      server_host)
        case $line in
          "::0")
            HA_HOST="[::1]"
            ;;
          "0.0.0.0")
            HA_HOST="localhost"
            ;;
          *)
            HA_HOST=$line
        esac
        ;;
    esac
    key=
  fi
done

echo "TEST ${HA_PROTOCOL}://$HA_HOST:$HA_PORT"
curl --fail --insecure --silent --output /dev/null --write-out 'HTTP Code %{http_code}' "${HA_PROTOCOL}://$HA_HOST:$HA_PORT" || exit 1
