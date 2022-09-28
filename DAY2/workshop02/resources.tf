resource digitalocean_ssh_key wkday {
  name = "wkday"
  public_key = file(var.public_key)
}

resource digitalocean_droplet nginx2 {
  image  = var.DO_image
  name   = "nginx2"
  region = var.DO_region
  size   = var.DO_size
  ssh_keys = [digitalocean_ssh_key.wkday.id]

  connection {
    type = "ssh"
    user = "root"
    host = self.ipv4_address
    private_key = file(var.private_key)
  }


}

resource local_file root_at_ip {
    content = ""
    filename = "root@${digitalocean_droplet.nginx2.ipv4_address}"
}

output nginx_ip {
    description = "Nginx IP"
    value = digitalocean_droplet.nginx2.ipv4_address
}
