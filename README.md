# nicehash-excavator-influx-exporter
🔌 A tiny tool to export NiceHash's excavator metrics

Demo -> [dashboard.starry.blue](https://dashboard.starry.blue/d/Hcy3ScsGz/cryptocurrency?orgId=1&refresh=10s)

[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/slashnephy/nicehash-excavator-influx-exporter/latest)](https://hub.docker.com/r/slashnephy/nicehash-excavator-influx-exporter)

`docker-compose.yml`

```yaml
version: '3.8'
services:
  influxdb:
    container_name: InfluxDB
    image: influxdb
    restart: always
    volumes:
      - influxdb:/var/lib/influxdb

  nicehash-excavator-exporter:
    container_name: nicehash-excavator-exporter
    image: slashnephy/nicehash-excavator-influx-exporter:latest
    restart: always
    environment:
      # メトリックの取得間隔 (秒)
      INTERVAL: 10
      # NiceHash Excavator の API アドレス
      EXCAVATOR_ADDR: http://nicehash-excavator:18000
      # GPU ID
      GPU_ID: GPU_xxxxxx-xxxx
      # InfluxDB アドレス
      INFLUX_ADDR: http://influxdb:8086
      # InfluxDB データベース名
      INFLUX_DB: nicehash

volumes:
  influxdb:
    local: driver
```
