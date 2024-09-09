#!/bin/bash
echo "init-bench.sh"
printf '%*s' 10 | tr ' ' '\n'


export PYENV_VERSION=3.11.6

# nvm use 18.18.2

# install jq for get-app with apps.sh
sudo wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
&& sudo chmod +x ./jq \
&& sudo cp jq /usr/bin \
&& chmod  +x /workspace/apps.sh

if [ ! -d "/workspace/frappe-bench" ]; then
    echo "running bench init."
    printf '%*s' 10 | tr ' ' '\n'

    # permissions issues .. may be better way for frappe to have write perms
    sudo mkdir -p /workspace/frappe-bench
    sudo chmod 777 /workspace/frappe-bench
    ls -al 

    # uncomment to install apps from app.json , else only frappe will be fetched

    bench init --verbose \
    --skip-redis-config-generation \
    --frappe-path=https://github.com/frappe/frappe \
    --frappe-branch=version-15 \
    --ignore-exist frappe-bench

    cd /workspace/frappe-bench
    # important for podman to use network, set container name of mariadb
    bench set-mariadb-host version-15_mariadb_1

    bench set-config -g db_type mariadb
    bench set-config -g redis_cache redis://redis-queue:6379
    bench set-config -g redis_queue redis://redis-queue:6379
    bench set-config -g redis_socketio redis://redis-queue:6379
    bench set-config -g developer_mode 1

    # enable for individual sites if required
    bench set-config -g mute_emails true
else
    echo "bench exists. Skipped bench init"
    printf '%*s' 10 | tr ' ' '\n'
fi

cd /workspace/frappe-bench && bench start && cat

# To keep running without bench start
# cd /workspace/frappe-bench && tail -f /dev/null
