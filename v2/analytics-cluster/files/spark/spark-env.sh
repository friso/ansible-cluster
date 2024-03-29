#!/usr/bin/env bash

# This file contains environment variables required to run Spark. Copy it as
# spark-env.sh and edit that to configure Spark for your site.
#
# The following variables can be set in this file:
# - SPARK_LOCAL_IP, to set the IP address Spark binds to on this node
# - MESOS_NATIVE_LIBRARY, to point to your libmesos.so if you use Mesos
# - SPARK_JAVA_OPTS, to set node-specific JVM options for Spark. Note that
#   we recommend setting app-wide options in the application's driver program.
#     Examples of node-specific options : -Dspark.local.dir, GC options
#     Examples of app-wide options : -Dspark.serializer
#
# If using the standalone deploy mode, you can also set variables for it here:
# - SPARK_MASTER_IP, to bind the master to a different IP address or hostname
# - SPARK_MASTER_PORT / SPARK_MASTER_WEBUI_PORT, to use non-default ports
# - SPARK_WORKER_CORES, to set the number of cores to use on this machine
# - SPARK_WORKER_MEMORY, to set how much memory to use (e.g. 1000m, 2g)
# - SPARK_WORKER_PORT / SPARK_WORKER_WEBUI_PORT
# - SPARK_WORKER_INSTANCES, to set the number of worker processes per node
# - SPARK_WORKER_DIR, to set the working directory of worker processes

###
### === IMPORTANT ===
### Change the following to specify a real cluster's Master host
###
export SPARK_JAVA_OPTS="-Dspark.local.dir={{ spark_local_dirs | join(',') }} -Djava.net.preferIPv4Stack=true -Dspark.executor.memory=7g -Dspark.worker.timeout=600 -Dspark.akka.timeout=600 -Dspark.akka.heartbeat.pauses=600 -Dspark.akka.failure-detector.threshold=600 -Dspark.akka.heartbeat.interval=1000 -Dspark.storage.blockManagerTimeoutIntervalMs=600000"

# export STANDALONE_SPARK_MASTER_HOST={{ hostvars[groups['master'][0]].ansible_eth0.ipv4.address }}
# export SPARK_MASTER_IP={{ hostvars[groups['master'][0]].ansible_eth0.ipv4.address }}
# export SPARK_LOCAL_IP={{ ansible_eth0["ipv4"]["address"] }}
export STANDALONE_SPARK_MASTER_HOST={{ hostvars[groups['master'][0]].ansible_fqdn }}
export SPARK_MASTER_IP={{ hostvars[groups['master'][0]].ansible_fqdn }}
export SPARK_LOCAL_IP={{ ansible_fqdn }}

export SPARK_HOME=/usr/lib/spark
export REMOTE_SPARK_HOME=/usr/lib/spark

### Let's run everything with JVM runtime, instead of Scala
export SPARK_LAUNCH_WITH_SCALA=0
export SPARK_LIBRARY_PATH=${SPARK_HOME}/lib
export SCALA_LIBRARY_PATH=${SPARK_HOME}/lib
export SPARK_MASTER_WEBUI_PORT=18080
export SPARK_MASTER_PORT=7077
export SPARK_WORKER_PORT=7078
export SPARK_WORKER_WEBUI_PORT=18081
export SPARK_WORKER_DIR={{ spark_worker_dir }}
export SPARK_LOG_DIR=/var/log/spark


if [ -n "$HADOOP_HOME" ]; then
  export SPARK_LIBRARY_PATH=$SPARK_LIBRARY_PATH:${HADOOP_HOME}/lib/native
fi

PYSPARK_PYTHON=/usr/local/virtualenv/spark/bin/python

### Comment above 2 lines and uncomment the following if
### you want to run with scala version, that is included with the package
#export SCALA_HOME=${SCALA_HOME:-/usr/lib/spark/scala}
#export PATH=$PATH:$SCALA_HOME/bin
