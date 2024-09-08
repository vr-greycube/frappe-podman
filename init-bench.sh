#!/bin/bash

export PYENV_VERSION=3.11.6

# sleep 1

# nvm use 18.18.2

if [ ! -d "frappe-bench" ]; then
    echo "running bench init."

    # permissions issues .. may be better way for frappe to have write perms
    sudo mkdir frappe-bench
    sudo chown frappe:frappe frappe-bench
    sudo chmod 777 frapp-bench

    # --apps_path=apps.json

    bench init --verbose \
    --skip-redis-config-generation \
    --frappe-path=https://github.com/frappe/frappe \
    --frappe-branch=version-15 \
    --ignore-exist frappe-bench

    # important for podman to use network
    bench set-mariadb-host version-15_mariadb_1


    bench set-config -g db_type mariadb
    bench set-config -g redis_cache redis://redis-queue:6379
    bench set-config -g redis_queue redis://redis-queue:6379
    bench set-config -g redis_socketio redis://redis-queue:6379

    bench set-config developer_mode 1
else
    echo "bench exists. Skipped bench init"
fi

cd /workspace/frappe-bench && bench start

# To keep running without bench start
# cd /workspace/frappe-bench && tail -f /dev/null
