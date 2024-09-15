terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key"
  type        = string
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "SSH_Key" {
  name = "SSH_Key"
}

resource "digitalocean_droplet" "Caldera" {
  name   = "Caldera"
  image  = "debian-12-x64"
  size   = "s-2vcpu-4gb"
  region = "lon1"
  tags   = ["Caldera"]

  ssh_keys = [data.digitalocean_ssh_key.Caldera.id]

  provisioner "remote-exec" {
  inline = [
    "while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do echo 'Waiting for dpkg lock'; sleep 1; done",
    "sudo apt-get update",
    "sudo apt-get install -y ca-certificates curl git",
    "sudo install -m 0755 -d /etc/apt/keyrings",
    "sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc",
    "sudo chmod a+r /etc/apt/keyrings/docker.asc",
    "echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
    "sudo apt-get update",
    "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
    "sudo apt-get install -y git",
    "sudo apt-get update",
    "sudo mkdir -p /docker",
    "cd docker",
    "git clone https://github.com/mitre/caldera.git --recursive",
    "cd caldera",
    "docker build . --build-arg WIN_BUILD=true -t caldera:server",
    "docker run -p 7010:7010 -p 7011:7011/udp -p 7012:7012 -p 8888:8888 caldera:server"
  ]

    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = "root"
      private_key = file(var.ssh_private_key_path)
    }
  }
}

resource "digitalocean_project" "Caldera" {
  name        = "Caldera"
  description = "Automated Adversary Emulation"
  purpose     = "CyberSecurity Project"
  environment = "Production"
  resources   = [digitalocean_droplet.Caldera.urn]
}