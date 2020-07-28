#!/bin/bash 


set -e

is_master=$(cat /emr/instance-controller/lib/info/instance.json | jq .isMaster)

if [ $is_master != "true" ]; then
        is_master="false"
fi

SCRIPT=$(cat <<EOF

while [ "\$(sed '/localInstance {/{:1; /}/!{N; b1}; /nodeProvision/p}; d' /emr/instance-controller/lib/info/job-flow-state.txt | sed '/nodeProvisionCheckinRecord {/{:1; /}/!{N; b1}; /status/p}; d' | awk '/SUCCESSFUL/' | xargs)" != "status: SUCCESSFUL" ];
    do
      sleep 1
    done
     
     # Move the jar out from the classpath on all the nodes
     sudo mv /usr/share/aws/emr/ddb/lib/emr-dynamodb-hadoop-* /home/hadoop/
     exit 0


EOF
    )

    echo "${SCRIPT}" | tee -a /tmp/ba_script.sh
    chmod u+x /tmp/ba_script.sh
    /tmp/ba_script.sh > /tmp/ba_script.log 2>&1 &

