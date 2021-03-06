#!/usr/bin/env bash
# call supervisor..
#TODO move this somewhere else.
sh -c "/usr/bin/supervisord" &

cd /usr/local/spark
export SPARK_LOCAL_IP=`awk 'NR==2 {print $1}' /etc/hosts`
./bin/spark-class org.apache.spark.deploy.worker.Worker \
	spark://${SPARK_MASTER_PORT_7077_TCP_ADDR}:${SPARK_MASTER_ENV_SPARK_MASTER_PORT} \
	--properties-file /spark-defaults.conf \
	-i $SPARK_LOCAL_IP \
	"$@"
