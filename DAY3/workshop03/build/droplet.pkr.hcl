source digitalocean codeserver {
api_token = var.DO_TOKEN
region = var.region
size = var.droplet.size
image = var.droplet.image
snapshot_name = "codeserver-snapshot"
ssh_username = "root"
}

build {
    sources = [ "source.digitalocean.codeserver" ]

    provisioner file {
        source = "setup.sh"
        destination = "/tmp/"
    }

provisioner shell {
inline = [
"chmod a+x /tmp/setup.sh",
"/tmp/setup.sh"
]
}

}