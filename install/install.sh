#!/bin/bash


function install_prometheus() {
	tar -xvf Packages/prometheus-2.8.0.linux-amd64.tar.gz -C /usr/local/
	useradd -u 8001 -s /sbin/nologin -M prometheus

	mkdir /etc/prometheus
	mkdir /data/prometheus -p
	chown prometheus:prometheus /etc/prometheus/
	chown prometheus:prometheus /data/prometheus/

	cp /usr/local/prometheus-2.8.0.linux-amd64/promtool /usr/local/bin/
	cp /usr/local/prometheus-2.8.0.linux-amd64/prometheus /usr/local/bin/
	chown  prometheus:prometheus /usr/local/bin/prom*

	cp -r /usr/local/prometheus-2.8.0.linux-amd64/ /etc/prometheus/
	cp -r /usr/local/prometheus-2.8.0.linux-amd64/console_libraries/ /etc/prometheus/

	chown -R prometheus:prometheus /etc/prometheus/

        cp config/prometheus.yml /etc/prometheus/
        cp config/prometheus.service  /usr/lib/systemd/system/
    
        systemctl daemon-reload
        systemctl enable prometheus.service
        systemctl start prometheus.service
}

function install_grafana() {
        yum install grafana
	systemctl enable grafana-server.service
        cp config/dashboards.yaml /etc/grafana/provisioning/dashboards/
        cp config/datasources.yaml /etc/grafana/provisioning/datasources/
        chown root:grafana /etc/grafana/provisioning/dashboards/dashboards.yaml
        chown root:grafana /etc/grafana/provisioning/datasources/datasources.yaml
        cp -r dashboards  /var/lib/grafana/
	systemctl start grafana-server.service
}

function install_exporter(){
       tar xvf  Packages/node_exporter-0.17.0.linux-amd64.tar.gz -C /usr/local/
       useradd -u 8002 -s /sbin/nologin -M node_exporter
       cp /usr/local/node_exporter-0.17.0.linux-amd64/node_exporter /usr/local/bin/
       chown node_exporter:node_exporter /usr/local/bin/node_exporter
       cp config/node_exporter.service  /usr/lib/systemd/system/
       systemctl daemon-reload
       systemctl enable node_exporter.service
       systemctl start node_exporter.service
}
 

install_prometheus
install_grafana
install_exporter
