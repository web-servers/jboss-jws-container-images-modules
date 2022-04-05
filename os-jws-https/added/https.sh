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
https="<!-- No HTTPS configuration discovered -->"
if [ -n "${JWS_HTTPS_CACERTIFICATE}" ] ; then
https="\
<Connector port=\"8443\" protocol=\"HTTP/1.1\" \
maxThreads=\"150\" SSLEnabled=\"true\"> \
<SSLHostConfig caCertificateFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CACERTIFICATE}\" certificateVerification=\"required\"> \
<Certificate certificateFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE}\" \
${password} \
certificateKeyFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE_KEY}\"/> \
</SSLHostConfig> \
</Connector>"
else
https="\
<Connector port=\"8443\" protocol=\"HTTP/1.1\" \
maxThreads=\"150\" SSLEnabled=\"true\"> \
<SSLHostConfig> \
<Certificate certificateFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE}\" \
${password} \
certificateKeyFile=\"${JWS_HTTPS_CERTIFICATE_DIR}/${JWS_HTTPS_CERTIFICATE_KEY}\"/> \
</SSLHostConfig> \
</Connector>"
fi
  sed -i "s|### HTTPS_CONNECTOR ###|${https}|" $JWS_HOME/conf/server.xml
}
