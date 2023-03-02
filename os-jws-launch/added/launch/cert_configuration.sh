function preConfigure() {
  connector_setup
}


function connector_setup(){
FILE=`find /opt -name server.xml`
  if [ -z "${FILE}" ]; then
    FILE=`find /deployments -name server.xml`
  fi
  https="<!-- No HTTPS configuration discovered -->"
  if [ -f "/tls/server.crt" -a -f "/tls/server.key" -a -f "/tls/ca.crt" ] ; then
    https="<Connector port=\"8443\" protocol=\"HTTP/1.1\" maxThreads=\"200\" SSLEnabled=\"true\"> <SSLHostConfig caCertificateFile=\"/tls/ca.crt\" certificateVerification=\"optional\"> <Certificate certificateFile=\"/tls/server.crt\" certificateKeyFile=\"/tls/server.key\"/> </SSLHostConfig> </Connector>"
  elif [ -d "/tls" -a -f "/tls/server.crt" -a -f "/tls/server.key" ] ; then
    https="<Connector port=\"8443\" protocol=\"HTTP/1.1\" maxThreads=\"200\" SSLEnabled=\"true\"> <SSLHostConfig> <Certificate certificateFile=\"/tls/server.crt\" certificateKeyFile=\"/tls/server.key\"/> </SSLHostConfig> </Connector>"
  elif [ ! -f "/tls/server.crt" -o ! -f "/tls/server.key" ] ; then
    log_warning "Partial HTTPS configuration, the https connector WILL NOT be configured."
  fi
  sed -i "/<Service name=/a ${https}" ${FILE}
}