#!/bin/bash

bench new-site demo15.localhost --force --db-name demo15 --admin-password 123 --db-root-username root --db-root-password 123 --no-mariadb-socket

# commands to create, rename user if required from dbeaver
# CREATE USER 'demo15'@'%' IDENTIFIED BY 'site_config-password';
# RENAME USER 'DEMO15'@'%' TO 'demo15'@'%' IDENTIFIED BY 'site_config-password';
# GRANT ALL PRIVILEGES ON demo15.* To 'demo15'@'%' IDENTIFIED BY 'site_config-password';