# bourne shell script snippet
# used by OpenShift JBoss Web Server launch script

source $JWS_HOME/bin/launch/logging.sh

function prepareEnv() {
  unset JWS_HTTPS_CERTIFICATE_DIR
  unset JWS_HTTPS_CERTIFICATE
  unset JWS_HTTPS_CERTIFICATE_KEY
  unset JWS_HTTPS_CERTIFICATE_PASSWORD
  unset JWS_SERVER_NAME
  unset JWS_HTTPS_CACERTIFICATE
}

function configure() {
  configure_https
}

function configure_https() {
  https="<!-- No HTTPS configuration discovered -->"
  password=""
  if [ -n "${JWS_HTTPS_CERTIFICATE_PASSWORD}" ] ; then
    password=" SSLPassword=\"${JWS_HTTPS_CERTIFICATE_PASSWORD}\" "
  fi
  servername=""
  if [ -n "${JWS_SERVER_NAME}" ]; then
    https="$https server=\"${JWS_SERVER_NAME}\""
  fi
  if [ -n "${JWS_HTTPS_CERTIFICATE_DIR}" -a -n "${JWS_HTTPS_CERTIFICATE}" -a -n "${JWS_HTTPS_CERTIFICATE_KEY}" -a -n "${JWS_HTTPS_CACERTIFICATE}" ] ; then
      https="<Connector port=\"8443\" protocol=\"HTTP/1.1\" maxThreads=\"200\" SSLEnabled=\"true\" ${password} ${servername}> \
      <SSLHostConfig caCertificateFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CACERTIFICATE}\" certificateVerification=\"optional\"> \
      <Certificate certificateFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE}\" certificateKeyFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE_KEY}\"/> \
      </SSLHostConfig> \
      </Connector>"
  elif [ -n "${JWS_HTTPS_CERTIFICATE_DIR}" -a -n "${JWS_HTTPS_CERTIFICATE}" -a -n "${JWS_HTTPS_CERTIFICATE_KEY}" ] ; then
      https="<Connector port=\"8443\" protocol=\"HTTP/1.1\" maxThreads=\"200\" SSLEnabled=\"true\" ${password} ${servername}> \
      <SSLHostConfig> <Certificate certificateFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE}\" certificateKeyFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE_KEY}\"/> \
      </SSLHostConfig> \
      </Connector>"
  elif [ ! -n "${JWS_HTTPS_CERTIFICATE}" -o ! -n "${JWS_HTTPS_CERTIFICATE_KEY}" ] ; then
      log_warning "Partial HTTPS configuration, the https connector WILL NOT be configured."
  fi
  sed -i "s|### HTTPS_CONNECTOR ###|${https}|" $JWS_HOME/conf/server.xml
}
