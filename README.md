# Generate nginx config based on env vars

Utility to map env vars by convention to proxy settings.

## Requirements

* [gettext/envsubst](https://www.gnu.org/software/gettext/gettext.html) which is included
in [alpine linux](https://pkgs.alpinelinux.org/package/edge/main/x86_64/gettext) attow.

## Usage

Assuming your environment variables define zero or more of

```sh
export <CUSTOM_PREFIX:API>_PROXY_ENDPOINT_<PROXY_NAME>=https://example.com
export <CUSTOM_PREFIX:API>_PROXY_PATH_<PROXY_NAME>=/example
```

Executing `./generate-proxy-config.sh` creates a proxy setting for you to be used with nginx.

As an example:

```sh

export API_PROXY_ENDPOINT_FOO_BAR=https://blah.example.com/foobar
export API_PROXY_PATH_FOO_BAR=foo/bar
export API_PROXY_ENDPOINT_FOO_BAZ=https://blah.example.com/foobaz
export API_PROXY_PATH_FOO_BAZ=foo/baz

./generate-proxy-config.sh

```

writes to `./proxy.conf`:

```
location foo/bar/ {
    proxy_pass https://blah.example.com/foobar;
}

location foo/baz/ {
    proxy_pass https://blah.example.com/foobaz;
}

```

Or, equivalent to the above with custom namespace and custom output path:

```sh

export MY_SERVICE_API_PROXY_ENDPOINT_FOO_BAR=https://my-service.example.com/foobar
export MY_SERVICE_API_PROXY_PATH_FOO_BAR=/my-service/foobar

./generate-proxy-config.sh MY_SERVICE_API  /etc/nginx/proxy.conf

```

writes to ` /etc/nginx/proxy.conf`:

```
location /my-service/foobar/ {
    proxy_pass https://my-service.example.com/foobar;
}


```

You can now either reference it or directly embed it in your default.conf:

```smartyconfig
# Your default.conf.tpl
server {
    # basic config

    # **********************************************************
    # start env-based proxy config
    # end env-based proxy config
    # **********************************************************
}
```

Replace the `# start env-based proxy config`-Line:

```sh
sed "/# start env-based proxy config/r proxy.conf" default.conf.tpl >| default.conf
```

### Test framework

See [rylnd/shpec](https://github.com/rylnd/shpec)
