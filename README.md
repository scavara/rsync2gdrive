# rsync2gdrive
* copy/sync cameras recordings stored on homeassistant running on rpi4 to google drive
```
├── etc
│   ├── default
│   │   └── prometheus-process-exporter # export metrics needed by grafana-dash
│   └── systemd
│       └── system
│           ├── sync2gdrive.service # sync2drive service unit
│           └── sync2gdrive.timer # 10m timer
├── grafana-dash.json # monitor and alert sync2gdrive
├── home
│   └── scavara/.local/bin/sync2gdrive.sh
├── README.md
└── rsync-ha-rpi4.tar.gz # HA doesn't have rsync installed. alt is to use ssh addon which has 'package' option.
```
* NOTES:
```
apt install -y software-properties-common dirmngr
sh -c "echo 'deb http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu xenial main' >> /etc/apt/sources.list.d/alessandro-strada-ubuntu-ppa-xenial.list"
sh -c "echo 'deb-src http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu xenial main' >> /etc/apt/sources.list.d/alessandro-strada-ubuntu-ppa-xenial.list"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AD5F235DF639B041
apt-get update
apt-get install -y google-drive-ocamlfuse
apt install prometheus-process-exporter

google-drive-ocamlfuse -id *************.apps.googleusercontent.com -secret ***************
if [[ ! -d /home/scavara/gdrive ]];then mkdir /home/scavara/gdrive;else echo "/home/scavara/gdrive already exists";fi
google-drive-ocamlfuse /home/scavara/gdrive


scavara@media:~ $ crontab -l
*/10 * * * * $HOME/.local/bin/sync2gdrive.sh
0 0 * * * find $HOME/gdrive/Home\ Surveillance\ Recordings/*/* -mtime +30 -delete

diff --git a/prometheus.yml b/prometheus.yml
+  - job_name: 'proccess-exporter'
+    scrape_interval: 1m
+    static_configs:
+      - targets:
+        - media.lan:9256
+    metric_relabel_configs:
+      - source_labels: [__name__]
+        regex: "namedprocess_namegroup_context_switches_total|namedprocess_namegroup_context_switches_total|namedprocess_namegroup_cpu_seconds_total|namedprocess_namegroup_cpu_seconds_total|namedprocess_namegroup_major_page_faults_total|namedprocess_namegroup_memory_bytes|namedprocess_namegroup_memory_bytes|namedprocess_namegroup_memory_bytes|namedprocess_namegroup_memory_bytes|namedprocess_namegroup_memory_bytes|namedprocess_namegroup_minor_page_faults_total|namedprocess_namegroup_num_procs|namedprocess_namegroup_num_threads|namedprocess_namegroup_oldest_start_time_seconds|namedprocess_namegroup_open_filedesc|namedprocess_namegroup_read_bytes_total|namedprocess_namegroup_states|namedprocess_namegroup_states|namedprocess_namegroup_states|namedprocess_namegroup_states|namedprocess_namegroup_states|namedprocess_namegroup_worst_fd_ratio|namedprocess_namegroup_write_bytes_total"
+        action: keep
```

sources and thanks:
* https://github.com/astrada/google-drive-ocamlfuse
* https://github.com/ncabatoff/process-exporter
