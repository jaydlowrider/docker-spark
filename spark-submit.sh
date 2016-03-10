#!/usr/bin/env bash
docker run -d -t -P --link spark_master:spark_master jaydlowrider/spark-docker /spark-submit.sh "$@"


