# Update the package index
apt-get update

# Install prerequisites
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Set up the Docker repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package index again
apt-get update

# Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io

# Start Docker
systemctl start docker
systemctl enable docker
