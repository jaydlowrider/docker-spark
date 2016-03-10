#!/usr/bin/env bash
#docker pull epahomov/docker-spark
docker run -i -t -P --link spark_master:spark_master jaydlowrider/spark-docker /spark-shell.sh "$@"
