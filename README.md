# Caldera

This repository offers bootstrap options to deploy a Mitre Caldera server manually, with Docker or via Terraform into DigitalOcean(Update Terraform for a different environment).

MITRE Caldera™ is a cyber security platform designed to easily automate adversary emulation, assist manual red-teams, and automate incident response.

It is built on the MITRE ATT&CK™ framework and is an active research project at MITRE.

The framework consists of two components:

The core system is an asynchronous command-and-control (C2) server with a REST API and a web interface.

# Manual Installation(Linux Debian)
## Requirements

```deploy a Linux Debian Droplet in DO project```
```access droplet cli```

**Install and configure GIT**

```sudo apt update```
``` sudo apt install -y git```

verify installation with 
```git --version```

Clone this repository

```git clone https://github.com/BurnyMack/Caldera.git```

**Installation**

cd in caldera directory 
```cd caldera```

run install script
```bash install.sh```

# Terraform Installation(on Linux Debian droplet)

1.Clone this repository
```git clone https://github.com/BurnyMack/Caldera.git```

2.Create SSH key pair in SSH Client and Paste public key in DO

3.Create API key in DO

4.Enter both variables into a local ```terraform.tfvars``` file

5.install terraform
6.```terraform init```
7.```terraform plan```
8.```terraform apply```

**References**
https://caldera.readthedocs.io/en/stable/Installing-Caldera.html
