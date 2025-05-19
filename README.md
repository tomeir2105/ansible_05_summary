# Ansible Playbook - Task 05

## Overview
- This project contains an Ansible playbook to manage remote servers. 
- It demonstrates tasks such as copying scripts to remote machines, executing them, and checking system conditions like the existence of 
  directories.
- The playbook is designed to be used across multiple servers, with detailed steps for setup and execution.

# The Short way 
(Includes downloading the ansible docker machines)
```bash
curl -o run.sh https://raw.githubusercontent.com/tomeir2105/ansible_05_summary/main/first_install/run.sh
chmod +x run.sh
./run.sh
```

# The Long Long Way -
## Prerequisites
- Before running the playbook, download extract and start the ansible dockers from :
  https://gitlab.com/vaiolabs-io/ansible-shallow-dive/-/archive/main/ansible-shallow-dive-main.tar.gz
  cd int the docker build script - 
```bash
cd ./ansible-shallow-dive/99_misc/setup/docker
docker compose up -d
docker exec -it docker-ansible-host-1 /bin/bash
git clone https://github.com/tomeir2105/ansible_05_summary.git
```  
## Running the playbook
After cloning the repository, step into the folder and run the playbook.
```bash
cd ansible_05_summary
ansible-playbook playbook.yaml
```
## Remarks and features
- ssh error - i added in ansible.cfg a host_key_checking = False definition.
- mode: '0755' - change script permissions to execute.
- use of when: statement to check that the folder tmp exists.
- use of jinja statement - {{ result.stdout }} to print the debug output of the script.


