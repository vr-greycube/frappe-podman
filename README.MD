# A basic setup for custom app development using Podman (instead of Docker)

For a complete setup that uses Docker please refer [https://github.com/frappe/frappe_docker.git](https://github.com/frappe/frappe_docker.git)

To "get" apps in bench from apps.json
```
cd /workspace/frappe-bench
../apps.sh
```
The bench created in container is owned by the frappe user in the container. So to edit code in vscode, after bench has been created, set acl for bench folders. If you have a bench named frappe-bench:
```
sudo setfacl -R -m u:v:rwX frappe-bench
sudo setfacl -R -m d:u:v:rwX frappe-bench
```
Some util commands to fix DB issues from dbeaver
```
CREATE USER 'demo15'@'%' IDENTIFIED BY 'site_config-password';
RENAME USER 'DEMO15'@'%' TO 'demo15'@'%' IDENTIFIED BY 'site_config-password';
GRANT ALL PRIVILEGES ON demo15.* To 'demo15'@'%' IDENTIFIED BY 'site_config-password';
```