
# mapping based on env vars:
#   ${PROXY_PATH_NAME} (location)
#   ${PROXY_ENDPOINT_NAME} (proxy_pass)
#
location ${PROXY_PATH}/ {
    proxy_pass ${PROXY_ENDPOINT};
}
