#!/usr/bin/env bash
export SPARK_LOCAL_IP=`awk 'NR==1 {print $1}' /etc/hosts`


/remove_alias.sh # problems with hostname alias, see https://issues.apache.org/jira/browse/SPARK-6680
cd /usr/local/spark
./bin/spark-submit \
           --master spark://${SPARK_MASTER_PORT_7077_TCP_ADDR}:${SPARK_MASTER_ENV_SPARK_MASTER_PORT}  \
           --class com.zebra.broker.AMQSparkConsumer \
           --properties-file /spark-defaults.conf \
	   --deploy-mode cluster \
           --executor-memory 4G \
           --total-executor-cores 3 \
           /bar-aggregation-service-all-1.0.jar \
           2016-03-04 \
           tcp://172.17.42.1 \
           test.topic

