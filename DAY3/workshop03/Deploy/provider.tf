terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.22.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.22.3"
  }
  }
}
provider "docker" {
  host = "unix:///var/run/docker.sock"
  # Configuration options
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.DO_token
}

provider local { }
