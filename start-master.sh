#!/usr/bin/env bash
#docker pull epahomov/docker-spark
docker run -d -t -P --name spark_master jaydlowrider/spark-docker /start-master.sh "$@"
