#!/usr/bin/env bash

describe "generate-proxy-config"
  describe "not a single env var matching"
    it "creates empty file"
      ./generate-proxy-config.sh SHPEC_API_NS_PREFIX__SOLELY__FOR__TESTING_EMPTY shpec/case1a.proxy.conf
      assert blank $(cat shpec/case1a.proxy.conf)
    end
    it "purges a previously defined file"
      touch shpec/case1b.proxy.conf
      echo "FOOOOO" >> shpec/case1b.proxy.conf
      ./generate-proxy-config.sh SHPEC_API_NS_PREFIX__SOLELY__FOR__TESTING_EMPTY shpec/case1b.proxy.conf
      assert blank $(cat shpec/case1b.proxy.conf)
    end
  end

  describe "env vars provided"
    it "generates file containing single corresponding config"

      export SHPEC_API_NS_PREFIX__SOLELY__FOR__TESTING_PROXY_ENDPOINT_FOO=http://foo.example.com; \
      export SHPEC_API_NS_PREFIX__SOLELY__FOR__TESTING_PROXY_PATH_FOO=/example/foo; \
      $( ./generate-proxy-config.sh SHPEC_API_NS_PREFIX__SOLELY__FOR__TESTING shpec/case2a.proxy.conf ) &> /dev/null
      assert equal "$(echo $(cat shpec/case2a.proxy.conf | grep "^location "))" "location /example/foo/ {"
      assert equal "$(echo $(cat shpec/case2a.proxy.conf | grep "^    proxy_pass "))" "proxy_pass http://foo.example.com;"
    end

    it "generates file containing multiple corresponding configs"
      export SHPEC_API_NS_PREFIX__SOLELY__FOR__TESTING_PROXY_ENDPOINT_FOO=http://foo.example.com; \
      export SHPEC_API_NS_PREFIX__SOLELY__FOR__TESTING_PROXY_PATH_FOO=/foo; \
      export SHPEC_API_NS_PREFIX__SOLELY__FOR__TESTING_PROXY_ENDPOINT_BAR=http://bar.example.com; \
      export SHPEC_API_NS_PREFIX__SOLELY__FOR__TESTING_PROXY_PATH_BAR=/bar; \
      $( ./generate-proxy-config.sh SHPEC_API_NS_PREFIX__SOLELY__FOR__TESTING shpec/case2b.proxy.conf ) &> /dev/null
      assert equal "$(echo $(cat shpec/case2b.proxy.conf | grep "^location \/foo"))" "location /foo/ {"
      assert equal "$(echo $(cat shpec/case2b.proxy.conf | grep "^    proxy_pass http:\/\/foo"))" "proxy_pass http://foo.example.com;"
      assert equal "$(echo $(cat shpec/case2b.proxy.conf | grep "^location \/bar"))" "location /bar/ {"
      assert equal "$(echo $(cat shpec/case2b.proxy.conf | grep "^    proxy_pass http:\/\/bar"))" "proxy_pass http://bar.example.com;"
    end
  end
end
