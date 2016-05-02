#!/bin/bash
set -o errexit
set -o pipefail

CB_REST_USERNAME=${USERNAME:-aptible}
CB_REST_PASSWORD=${PASSPHRASE}

ARGUMENT_FILE="$CONFIG_DIRECTORY/cluster-init.args"
LOG_FILE=/opt/couchbase/var/lib/couchbase/logs/debug.log

wait_for_cluster() {
  for i in $(seq 10 -1 0); do
    if curl -s localhost:8091 > /dev/null; then
      break
    fi

    if [ "$i" -eq 0 ]; then
      echo "Couchbase never came online"
      false
    fi

    echo "Waiting until Couchbase comes online"
    sleep 2
  done
}

cb_init_config() {
  chown -R couchbase:couchbase "$CONFIG_DIRECTORY"

  cat <<EOM > $CONFIG_DIRECTORY/data.ini
[couchdb]
database_dir = $DATA_DIRECTORY
view_index_dir = $DATA_DIRECTORY
EOM

  cat <<EOM > $ARGUMENT_FILE
--cluster-username $CB_REST_USERNAME
--cluster-password $CB_REST_PASSWORD
EOM

}

cb_init_data() {
  chown -R couchbase:couchbase "$DATA_DIRECTORY"
  chmod go-rwx "$DATA_DIRECTORY"
}

cb_init_cluster() {
  wait_for_cluster
  # shellcheck disable=SC2046
  couchbase-cli cluster-init -c localhost:8091 \
                             --cluster-ramsize 1024 \
                             $(cat "$ARGUMENT_FILE")
}

cb_init() {
  cb_init_config
  cb_init_data
  /etc/init.d/couchbase-server start
  cb_init_cluster
  /etc/init.d/couchbase-server stop
}

cb_run_server() {
  /etc/init.d/couchbase-server start
  cb_init_cluster
}

if [[ "$1" == "--initialize" ]]; then
  cb_init

elif [[ "$1" == "--discover" ]]; then
  cat <<EOM
{
  "exposed_ports": [
    8091,
    8092,
    8093,
    9110,
    11207,
    11210,
    11211,
    18091,
    18092
  ]
}
EOM

else
  cb_run_server
  tail -F $LOG_FILE

fi
