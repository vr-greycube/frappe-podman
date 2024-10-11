#!/bin/bash

# IMPORTANT: use --no-mariadb-socket so that db user is create as 'user'@'%' instead of e.g. 'user'@'x.x.x.x'

bench new-site demo15.localhost --force --db-name demo15 --admin-password 123 \
--db-root-username root --db-root-password 123 --no-mariadb-socket \
# --install-app erpnext --install-app hrms --install-app payments --install-app india_compliance --install-app custom_app
