FROM prom/prometheus as prometheus

FROM grafana/grafana-oss as grafana

FROM ubuntu

WORKDIR /

COPY --from=prometheus /etc/prometheus/prometheus.yml /etc/prometheus/prometheus.yml
COPY --from=prometheus /usr/share/prometheus/console_libraries/ /usr/share/prometheus/console_libraries/ 
COPY --from=prometheus /usr/share/prometheus/consoles/ /usr/share/prometheus/consoles/ 
COPY --from=prometheus /bin/prometheus /bin/prometheus 

ENV PATH="/usr/share/grafana/bin:$PATH" \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

RUN echo $GF_PATHS_HOME

COPY --from=grafana $GF_PATHS_HOME $GF_PATHS_HOME
COPY --from=grafana $GF_PATHS_DATA $GF_PATHS_DATA
COPY --from=grafana $GF_PATHS_CONFIG $GF_PATHS_CONFIG
COPY --from=grafana $GF_PATHS_LOGS $GF_PATHS_LOGS
COPY --from=grafana $GF_PATHS_PLUGINS $GF_PATHS_PLUGINS
COPY --from=grafana $GF_PATHS_PROVISIONING $GF_PATHS_PROVISIONING 
COPY --from=grafana run.sh run.sh

RUN apt-get update \
  && apt-get install python3.11 -y \
  && apt-get install curl -y \
  && curl -O https://bootstrap.pypa.io/get-pip.py \
  && python3.11 get-pip.py \
  && pip install supervisor

COPY supervisord.conf /etc/supervisord.conf
COPY profana.sh profana.sh
RUN chmod 701 profana.sh

CMD ./profana.sh
