FROM ubuntu:15.10

MAINTAINER Pakhomov Egor <pahomov.egor@gmail.com>, Melvin Ramos <melvin.ramos@gmail.com> 
#making the libs more recent.


RUN apt-get -y -m update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -m --force-yes --fix-missing software-properties-common
RUN apt-add-repository -y ppa:webupd8team/java
RUN apt-get -y update
RUN apt-get -y install ssh
RUN apt-get -y install vim
RUN apt-get -y install autossh
RUN apt-get -y install telnet
RUN apt-get -y install supervisor
RUN mkdir -p /var/log/supervisor
RUN /bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install oracle-java8-installer oracle-java8-set-default

ADD opsworks.pem /opsworks.pem
RUN chmod 600 /opsworks.pem

RUN apt-get -y install curl
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.6.0-bin-hadoop2.6.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-1.6.0-bin-hadoop2.6 spark
ADD scripts/start-master.sh /start-master.sh
ADD scripts/start-worker.sh /start-worker.sh
ADD scripts/spark-shell.sh  /spark-shell.sh
ADD scripts/spark-defaults.conf /spark-defaults.conf
ADD scripts/remove_alias.sh /remove_alias.sh
ADD scripts/spark-submit.sh /spark-submit.sh
copy supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY bar-aggregation-service-all-1.0.jar /bar-aggregation-service-all-1.0.jar
ENV SPARK_HOME /usr/local/spark

ENV SPARK_MASTER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 -Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 -Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 -Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory"
ENV SPARK_WORKER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 -Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 -Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 -Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory"

ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_WORKER_PORT 8888
ENV SPARK_WORKER_WEBUI_PORT 8081


EXPOSE 8080 7077 8888 8081 4040 7001 7002 7003 7004 7005 7006 
