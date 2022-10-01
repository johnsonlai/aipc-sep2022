resource digitalocean_ssh_key wkday {
  name = "wkday"
  public_key = file(var.public_key)
}
resource digitalocean_droplet codeserver {
    name = "codeserver"
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region
    ssh_keys = [ digitalocean_ssh_key.wkday.id ]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.private_key)
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "sed -e 's/__CHANGE_THIS__/${var.codeserver_password}/' -i /lib/systemd/system/code-server.service",
      "sed -e 's/__CHANGE_THIS__/${var.codeserver_fqdn}/' -i /etc/nginx/sites-available/code-server.conf",
      "systemctl daemon-reload",
      "systemctl restart code-server",
      "systemctl restart nginx"
    ]
  }
}

resource local_file root_at_codeserver {
    content = "The IP address is ${digitalocean_droplet.codeserver.ipv4_address}"
    filename = "root@${digitalocean_droplet.codeserver.ipv4_address}"
    file_permission = 644
}

resource local_file inventory {
    filename = "inventory.yaml"
    content = templatefile("inventory.yaml.tftpl", {
        private_key = var.private_key
        droplet_ip = digitalocean_droplet.codeserver.ipv4_address
        codeserver_domain: "codeserver-${digitalocean_droplet.codeserver.ipv4_address}.nip.io"
        codeserver_password: var.codeserver_password
    })
    file_permission = 644
}

output codeserver_ip {
    value = digitalocean_droplet.codeserver.ipv4_address
}