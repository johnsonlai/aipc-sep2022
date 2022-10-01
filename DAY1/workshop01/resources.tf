resource digitalocean_ssh_key wkday {
  name = "wkday"
  public_key = file(var.public_key)
}

resource docker_image dovbear_image {
  name = "chukmunnlee/dov-bear:v2"
}

resource docker_container dovbear_container {
  count = var.replicas
  name = "dov-${count.index}"
  image = docker_image.dovbear_image.image_id
  ports {
    internal = 3000
    external = 30000 + count.index
  }
  env = [
    "INSTANCE_NAME=dov-${count.index}"
  ]
}

resource digitalocean_droplet nginx {
  image  = var.DO_image
  name   = "nginx"
  region = var.DO_region
  size   = var.DO_size
  ssh_keys = [digitalocean_ssh_key.wkday.id]

  connection {
    type = "ssh"
    user = "root"
    host = self.ipv4_address
    private_key = file(var.private_key)
  }

  // install nginx
    provisioner remote-exec {
        inline = [
            "apt update",
            "apt install -y nginx",
            "systemctl enable nginx",
            "systemctl start nginx",
        ]
    }

    provisioner file {
        source = "./${local_file.nginx_conf.filename}"
        destination = "/etc/nginx/nginx.conf"
    }

    provisioner remote-exec {
        inline = [
            "systemctl restart nginx"
        ]
    }
}

resource local_file root_at_ip {
    content = ""
    filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
}

resource local_file nginx_conf {
    filename = "nginx.conf"
    content = templatefile("nginx.conf.tftpl", {
        docker_host = "178.128.93.175"
        container_ports = local.ports
    })
}

locals {
    ports = [ for p in docker_container.dovbear_container[*].ports: p[0].external ]
}

output container_ports {
  description = "container ports"
  value = local.ports
}

output nginx_ip {
    description = "Nginx IP"
    value = digitalocean_droplet.nginx.ipv4_address
}
