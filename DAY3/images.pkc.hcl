variable DO_token {
    type = string
    sensitive = true
}

variable DO_image {
    type = string
    default = "ubunt-20-04-x64"
}

variable DO_size {
    type = string
    default = "s-1vcpu-1gb"
}

variable DO_region {
    type = string
    default = ""
}