terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Define variables
variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key"
  type        = string
}

# Define provider configuration
provider "digitalocean" {
  token = var.do_token
}

# Define SSH key data source
data "digitalocean_ssh_key" "Caldera" {
  name = "Caldera"
}

# Define project
resource "digitalocean_project" "Caldera" {
  name        = "Caldera"
  description = "Automate Adversary Emulation"
  purpose     = "CyberSecurity Project"
}

# Define droplet
resource "digitalocean_droplet" "Caldera" {
  name   = "Caldera"
  image  = "debian-12-x64"
  size   = "s-2vcpu-4gb"
  region = "lon1"
  tags   = ["Caldera"]

  ssh_keys = [data.digitalocean_ssh_key.Caldera.id]

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -",
      "add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "apt-get update",
      "apt-get install -y docker-ce docker-ce-cli containerd.io",
      "git clone https://github.com/mitre/caldera.git --recursive",
      "cd caldera && docker-compose up -d"
    ]

    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = "root"
      private_key = file(var.ssh_private_key_path)
    }
  }
}
