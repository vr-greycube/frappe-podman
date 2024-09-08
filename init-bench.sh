#!/bin/bash

export PYENV_VERSION=3.11.6

# sleep 1

# nvm use 18.18.2

if [ ! -d "frappe-bench" ]; then
    echo "running bench init."
#     # --apps_path=apps.json
    sudo mkdir frappe-bench
    sudo chown frappe:frappe frappe-bench
    bench init --skip-redis-config-generation --verbose --frappe-path=https://github.com/frappe/frappe \
    --frappe-branch=version-15  --ignore-exist frappe-bench
else
    echo "bench exists. Skipped bench init"
fi

# bench set-config -g db_type mariadb
# bench set-config -g redis_cache redis://redis-queue:6379
# bench set-config -g redis_queue redis://redis-queue:6379
# bench set-config -g redis_socketio redis://redis-queue:6379

# bench set-config developer_mode 1

# cd frappe-bench && tail -f /dev/null
# cd frappe-bench && bench start

tail -f /dev/null