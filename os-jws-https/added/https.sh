# bourne shell script snippet
# used by OpenShift JBoss Web Server launch script

source $JWS_HOME/bin/launch/logging.sh

function prepareEnv() {
  unset JWS_HTTPS_CERTIFICATE_DIR
  unset JWS_HTTPS_CERTIFICATE
  unset JWS_HTTPS_CERTIFICATE_KEY
  unset JWS_HTTPS_CERTIFICATE_PASSWORD
  unset JWS_SERVER_NAME
}

function configure() {
  configure_https
}

function configure_https() {
https="\
<Connector SSLEnabled="true" acceptCount="100" clientAuth="false" \
    disableUploadTimeout="true" enableLookups="false" maxThreads="25" \
    port="8443" keystoreFile="${JWS_HTTPS_CERTIFICATE_DIR}/.keystore" keystorePass="vmouriki" \
    protocol="org.apache.coyote.http11.Http11NioProtocol" scheme="https" \
    secure="true" sslProtocol="TLS" />"
  sed -i "s|### HTTPS_CONNECTOR ###|${https}|" $JWS_HOME/conf/server.xml
}
