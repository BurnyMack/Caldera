provider "digitalocean" {
  token = "digitalocean_api_token"
}

resource "digitalocean_droplet" "Caldera" {
  name   = "Caldera"
  image  = "ubuntu-20-04-x64"
  size   = "s-1vcpu-1gb"
  region = "nyc1"

 tags = ["caldera"]

variable "digitalocean_token" {
  description = "DigitalOcean API token"
  type        = string
}

# Output the Droplet IP address
output "droplet_ip" {
  value = digitalocean_droplet.my_droplet.ipv4_address
}
  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -",
      "add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "apt-get update",
      "apt-get install -y docker-ce docker-ce-cli containerd.io",
      "systemctl start docker",
      "systemctl enable docker",
      "git clone https://github.com/mitre/caldera.git --recursive",
      "docker-compose up -d"
    ]

    connection {
      type        = "ssh"
      host        = digitalocean_droplet.Caldera.ipv4_address
      user        = "root"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
