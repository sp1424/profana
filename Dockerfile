FROM prom/prometheus as prometheus


FROM grafana/grafana-oss as grafana

FROM ubuntu

WORKDIR /

COPY --from=prometheus /etc/prometheus/prometheus.yml /etc/prometheus/prometheus.yml
COPY --from=prometheus /usr/share/prometheus/console_libraries/ /usr/share/prometheus/console_libraries/ 
COPY --from=prometheus /usr/share/prometheus/consoles/ /usr/share/prometheus/consoles/ 
COPY --from=prometheus /bin/prometheus /bin/prometheus 

COPY run.sh run.sh
RUN chmod 701 run.sh

CMD ./run.sh
