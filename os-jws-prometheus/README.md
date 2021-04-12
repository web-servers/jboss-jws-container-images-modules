From https://github.com/apache/tomcat/blob/master/modules/stuffed/Dockerfile

Optional: Add Prometheus agent for JMX monitoring

RUN mkdir /opt/prometheus && wget https://repo.maven.apache.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.14.0/jmx_prometheus_javaagent-0.14.0.jar -O /opt/prometheus/prometheus.jar && wget https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/tomcat.yml -O conf/prometheus.yaml

ARG prometheusport=9404

ENV JAVA_OPTS="-javaagent:/opt/prometheus/prometheus.jar=$prometheusport:conf/prometheus.yaml ${JAVA_OPTS}"

EXPOSE $prometheusport
