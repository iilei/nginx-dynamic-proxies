# Generate nginx config based on env vars

example:

```sh

export API_PROXY_ENDPOINT_FOO_BAR=https://blah.example.com/foobar
export API_PROXY_PATH_FOO_BAR=foo/bar
export API_PROXY_ENDPOINT_FOO_BAZ=https://blah.example.com/foobaz
export API_PROXY_PATH_FOO_BAZ=foo/baz

./generate-proxy-config.sh

```

returns

```

# mapping based on env vars:
#   API_PROXY_PATH_FOO_BAR (location)
#   API_PROXY_ENDPOINT_FOO_BAR (proxy_pass)
location foo/bar/ {
    proxy_pass https://blah.example.com/foobar;
}

# mapping based on env vars:
#   API_PROXY_PATH_FOO_BAZ (location)
#   API_PROXY_ENDPOINT_FOO_BAZ (proxy_pass)
location foo/baz/ {
    proxy_pass https://blah.example.com/foobaz;
}

```

### Test framework

See [rylnd/shpec](https://github.com/rylnd/shpec)
