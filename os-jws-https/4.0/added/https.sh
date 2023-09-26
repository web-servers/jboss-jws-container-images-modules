# bourne shell script snippet
# used by OpenShift JBoss Web Server launch script

source $JWS_HOME/bin/launch/logging.sh

function prepareEnv() {
  unset JWS_HTTPS_CERTIFICATE_DIR
  unset JWS_HTTPS_CERTIFICATE
  unset JWS_HTTPS_CERTIFICATE_KEY
  unset JWS_HTTPS_CERTIFICATE_PASSWORD
  unset JWS_HTTPS_CERTIFICATE_CHAIN
  unset JWS_SERVER_NAME
}

function configure() {
  configure_https
}

function configure_https() {
  https="<!-- No HTTPS configuration discovered -->"
  if [ -n "${JWS_HTTPS_CERTIFICATE_DIR}" -a -n "${JWS_HTTPS_CERTIFICATE}" -a -n "${JWS_HTTPS_CERTIFICATE_KEY}" ] ; then

      https="<Connector \
             protocol=\"org.apache.coyote.http11.Http11NioProtocol\" \
             port=\"8443\" maxThreads=\"200\" \
             SSLEnabled=\"true\" \
	     sslImplementationName=\"org.apache.tomcat.util.net.openssl.OpenSSLImplementation\""

      if [ -n "$JWS_SERVER_NAME" ]; then
        https="$https server=\"${JWS_SERVER_NAME}\""
      fi

      https="$https >"
      
      https="$https \
	      <SSLHostConfig> \
                <Certificate \
                  certificateFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE}\" \
                  certificateKeyFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE_KEY}\""

      if [ -n "${JWS_HTTPS_CERTIFICATE_PASSWORD}" ] ; then
        https="$https \
	  certificateKeyPassword=\"${JWS_HTTPS_CERTIFICATE_PASSWORD}\""
      fi

      if [ -n "${JWS_HTTPS_CERTIFICATE_CHAIN}" ]; then
        https="$https \
	  certificateChainFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE_CHAIN}\""
      fi

       https="$https \
                  type=\"RSA\" \
                /> \
              </SSLHostConfig> \
	    </Connector>"  

  elif [ -n "${JWS_HTTPS_CERTIFICATE_DIR}" -o -n "${JWS_HTTPS_CERTIFICATE}" -o -n "${JWS_HTTPS_CERTIFICATE_KEY}" -o -n "${JWS_HTTPS_CERTIFICATE_PASSWORD}" -o -n "${JWS_HTTPS_CERTIFICATE_CHAIN}" ] ; then
      log_warning "Partial HTTPS certificate configuration, the https connector WILL NOT be configured."
  fi
  sed -i "s|### HTTPS_CONNECTOR ###|${https}|" $JWS_HOME/conf/server.xml
}
