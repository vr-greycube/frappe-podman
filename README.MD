### setup development benches using Podman


#### apps
to "get" apps in bench from apps.json
```
cd /workspace/frappe-bench
../apps.sh
```


#### to edit code in vscode
After bench has been created, set acl so files can be edited in host vscode

```
sudo setfacl -R -m u:v:rwX frappe-bench
sudo setfacl -R -m d:u:v:rwX frappe-bench
```

#### util commands to fix DB issues from dbeaver

```
CREATE USER 'demo15'@'%' IDENTIFIED BY 'site_config-password';
RENAME USER 'DEMO15'@'%' TO 'demo15'@'%' IDENTIFIED BY 'site_config-password';
GRANT ALL PRIVILEGES ON demo15.* To 'demo15'@'%' IDENTIFIED BY 'site_config-password';
```