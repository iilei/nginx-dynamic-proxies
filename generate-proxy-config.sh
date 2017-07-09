#!/usr/bin/env bash

NAMESPACE=${1:-API}
OUTFILE=${2:-./proxy.conf}

DELIM="_"
PROXY_ENDPOINT_PREFIX="${NAMESPACE}${DELIM}PROXY_ENDPOINT"
PROXY_PATH_PREFIX="${NAMESPACE}${DELIM}PROXY_PATH"

echo "Purge $OUTFILE"

touch "$OUTFILE"
:> "$OUTFILE"

echo "Preparing to configure Proxy settings based on environment vars"

proxies=$( compgen -A variable | grep -E "${PROXY_PATH_PREFIX}${DELIM}" )

for proxy in $proxies; do
  export PROXY_PATH_NAME=$proxy
  export PROXY_PATH_NAME_NS=$(echo $PROXY_PATH_NAME | sed "s/^${PROXY_PATH_PREFIX}${DELIM}//g")
  export PROXY_ENDPOINT_NAME="${PROXY_ENDPOINT_PREFIX}${DELIM}${PROXY_PATH_NAME_NS}"
  export PROXY_PATH=${!PROXY_PATH_NAME}
  export PROXY_ENDPOINT=${!PROXY_ENDPOINT_NAME}

  envsubst < ./proxy.conf.tpl >> "$OUTFILE"
done;

cat $OUTFILE;
