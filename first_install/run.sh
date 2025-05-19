#!/bin/bash
set -e
command_exists() { command -v "$1" &> /dev/null; }
install_curl() { sudo apt-get update -y &> /dev/null; sudo apt-get install -y curl &> /dev/null; }
for cmd in docker git curl; do
    if ! command_exists "$cmd"; then
        if [ "$cmd" == "curl" ]; then
            install_curl
        else
            echo "$cmd is not installed. Please install $cmd and try again."
            exit 1
        fi
    fi
done
curl -L -o ansible-shallow-dive.tar.gz https://gitlab.com/vaiolabs-io/ansible-shallow-dive/-/archive/main/ansible-shallow-dive-main.tar.gz || { echo "Curl download failed"; exit 1; }
tar -xzvf ansible-shallow-dive.tar.gz --strip-components=1 || { echo "Tar extraction failed"; exit 1; }
cd ./ansible-shallow-dive/99_misc/setup/docker || { echo "Directory not found"; exit 1; }
if ! docker compose ps --services --filter "status=running" | grep -q docker-ansible-host-1; then
    docker compose up -d || { echo "Docker Compose failed to start containers"; exit 1; }
fi
if ! ping -c 1 google.com &> /dev/null; then
    echo "No internet connection. Please check your network and try again."
    exit 1
fi
cd - > /dev/null
if [ -d "ansible_05_summary" ]; then
    sudo rm -rf ansible_05_summary || { echo "Failed to remove existing ansible_05_summary directory"; exit 1; }
fi
git clone https://github.com/tomeir2105/ansible_05_summary || { echo "Git clone failed"; exit 1; }
docker exec docker-ansible-host-1 bash -c "
    sudo mkdir -p /ansible_course/03_playbooks &&
    sudo chown -R ansible:ansible /ansible_course/03_playbooks/ &&
    sudo rm -rf /ansible_course/03_playbooks/ansible_05_summary
" || { echo "Docker exec command failed for creating directories or cleaning up"; exit 1; }
docker cp ansible_05_summary docker-ansible-host-1:/ansible_course/03_playbooks/ || { echo "Docker cp failed to copy files"; exit 1; }
docker exec docker-ansible-host-1 bash -c "
    sudo chmod -R +w /ansible_course/03_playbooks/ansible_05_summary
" || { echo "Docker exec failed to change file permissions"; exit 1; }
docker exec -it docker-ansible-host-1 bash -c "
    export ANSIBLE_HOST_KEY_CHECKING=False
    cd /ansible_course/03_playbooks/ansible_05_summary || exit 1
    ansible-playbook playbook.yaml
" || { echo "Playbook execution failed"; exit 1; }
