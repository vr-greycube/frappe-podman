# A basic setup for custom app development using Podman (instead of Docker)

Inspired by [castecraft](https://github.com/castlecraft/custom_containers). For a complete battle-tested setup that uses Docker please refer [frappe_docker](https://github.com/frappe/frappe_docker.git)

### Prerequisites
- podman
- podman-compose

```
git clone https://github.com/vr-greycube/frappe-podman.git version-15
cd frappe-podman
podman-compose up
```
The process has been split into 3 steps. This is so that it is easy to solve errors.
- create bench with bench init and just frappe
- install required apps with apps.sh
- install sites with create-site.sh

To "get" apps in bench from apps.json
```
podman exec -it <version-15_frappe_1> /bin/bash
cd /workspace/frappe-bench
../apps.sh
```
To create sites once the bench container is running, use the snippet from create-site.sh after podman exec into frappe container

### Multi bench
Change the bench name in init-bench.sh and ports in compose.yaml for subsequent benches.

Set appropriate PYTHON_VERSION and node version in init-bench.sh to create a version-14 bench

### vscode in host
The bench created in container is owned by the frappe user in the container. So to edit code in vscode, after bench has been created, set acl for bench folders. If you have a bench named frappe-bench:
```
sudo setfacl -R -m u:v:rwX frappe-bench
sudo setfacl -R -m d:u:v:rwX frappe-bench
```

### Debug setup
TBA

### Jupyter notebook
TBA

### DBeaver

Install [DBeaver](https://dbeaver.io/) for quick db edits & writing SQL. Some util commands to fix DB issues from dbeaver
```
use myql;
SELECT * from user;
CREATE USER 'demo15'@'%' IDENTIFIED BY 'site_config-password';
RENAME USER 'DEMO15'@'%' TO 'demo15'@'%' IDENTIFIED BY 'site_config-password';
GRANT ALL PRIVILEGES ON demo15.* To 'demo15'@'%' IDENTIFIED BY 'site_config-password';
```


# Setup for a fresh ubuntu machine
Setting up podman and podman-compose in Ubuntu 22.04

```
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install git curl gh -y
```

#### Add [Docker](https://docs.docker.com/engine/install/ubuntu/) dependencies for podman-compose

```
for pkg in docker.io docker-doc docker-compose \
docker-compose-v2 podman-docker containerd runc; \
do sudo apt-get remove $pkg; done

## Add Docker's official GPG key:

sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

## Add the repository to Apt sources:

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
```

Install docker-compose
```
sudo curl -L \
"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

Fix for a **cniVersion** error. Details [here](bugs://https.launchpad.net/ubuntu/+source/libpod/+bug/2024394) and [here](https://www.reddit.com/r/podman/comments/14f6frv/podman_automatically_sets_cniversion_100_instead/?rdt=34749)
```
curl -O http://archive.ubuntu.com/ubuntu/pool/universe/g/golang-github-containernetworking-plugins/containernetworking-plugins_1.1.1+ds1-3build1_amd64.deb

sudo dpkg -i containernetworking-plugins_1.1.1+ds1-3build1_amd64.deb
```

### Install podman
```
sudo apt-get -y install podman
podman run -dt -p 8080:80/tcp docker.io/library/httpd
podman ps
curl http://localhost:8080

sudo apt install -y podman-docker

systemctl --user enable --now podman.socket
systemctl --user status podman.socket
podman info | grep -i remotesocket -A2
curl -w "\n" -H "Content-Type: application/json" --unix-socket /run/user/$UID/podman/podman.sock http://localhost/_ping
```

### Install podman-compose

[Oracle podman compose](https://docs.oracle.com/en/learn/ol-podman-compose/#run-podman-compose)
```
sudo apt install python3-pip -y python3-dotenv

sudo curl -o /usr/local/bin/podman-compose https://raw.githubusercontent.com/containers/podman-compose/main/podman_compose.py
sudo chmod +x /usr/local/bin/podman-compose


mkdir -p projects/echo
cd projects/echo
cat >> compose.yaml << EOF
services:
  web:
    image: k8s.gcr.io/echoserver:1.4
    ports:
      - "${HOST_PORT:-8081}:8080"
EOF

podman-compose up -d
curl -X POST -d "foobar" http://localhost:8081/; echo
```


### Install Podman Desktop
```
sudo apt install flatpak -y
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub io.podman_desktop.PodmanDesktop
flatpak run io.podman_desktop.PodmanDesktop
```

Restart machine to be able to launch Podmand Desktop