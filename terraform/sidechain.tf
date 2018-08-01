provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_tag" "bootnode" {
  name = "bootnode"
}

resource "digitalocean_tag" "sidechain" {
  name = "sidechain"
}

resource "digitalocean_tag" "relay" {
  name = "relay"
}

resource "digitalocean_ssh_key" "default" {
  name       = "Sidechain"
  public_key = "${file("${var.public_key_path}")}"
}

resource "digitalocean_droplet" "bootnode" {
  image    = "ubuntu-18-04-x64"
  name     = "bootnode"
  region   = "${var.region}"
  size     = "s-1vcpu-1gb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  tags     = ["${digitalocean_tag.bootnode.id}"]

  provisioner "file" {
    source      = "../bootnode"
    destination = "/root/bootnode"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    script = "../bootnode/launch_bootnode.sh"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }
}

resource "digitalocean_droplet" "sealer1" {
  image    = "docker"
  name     = "sealer1"
  region   = "${var.region}"
  size     = "s-2vcpu-4gb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  tags     = ["${digitalocean_tag.sidechain.id}"]

  provisioner "file" {
    source      = "../bootnode"
    destination = "/root/bootnode"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "file" {
    source      = "../sidechain"
    destination = "/root/sidechain"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd sidechain",
      "chmod +x create_sealer.sh",
      "./create_sealer.sh ${digitalocean_droplet.bootnode.ipv4_address} 0x84b97f4ddddca458058d6047f6bb53672e76ada9"
    ]

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }
}

resource "digitalocean_droplet" "sealer2" {
  image    = "docker"
  name     = "sealer2"
  region   = "${var.region}"
  size     = "s-2vcpu-4gb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  tags     = ["${digitalocean_tag.sidechain.id}"]

  provisioner "file" {
    source      = "../bootnode"
    destination = "/root/bootnode"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "file" {
    source      = "../sidechain"
    destination = "/root/sidechain"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd sidechain",
      "chmod +x create_sealer.sh",
      "./create_sealer.sh ${digitalocean_droplet.bootnode.ipv4_address} 0x8caa3ee0f36ef860e26fd4aa104998b85f0583f3"
    ]

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }
}

resource "digitalocean_droplet" "sealer3" {
  image    = "docker"
  name     = "sealer3"
  region   = "${var.region}"
  size     = "s-2vcpu-4gb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  tags     = ["${digitalocean_tag.sidechain.id}"]

  provisioner "file" {
    source      = "../bootnode"
    destination = "/root/bootnode"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "file" {
    source      = "../sidechain"
    destination = "/root/sidechain"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd sidechain",
      "chmod +x create_sealer.sh",
      "./create_sealer.sh ${digitalocean_droplet.bootnode.ipv4_address} 0xa36e96217089ea4079d3eb39346f582c5566dec5"
    ]

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }
}

resource "digitalocean_volume" "relay1" {
  region      = "${var.region}"
  name        = "relay1"
  size        = 300
  description = "Holds the geth data"
}

resource "digitalocean_droplet" "relay1" {
  image    = "docker"
  name     = "relay1"
  region   = "${var.region}"
  size     = "s-2vcpu-4gb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  tags     = ["${digitalocean_tag.relay.id}"]
  volume_ids = ["${digitalocean_volume.relay1.id}"]

  provisioner "file" {
    source = "../relay1"
    destination = "/root/keystore"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "file" {
    source = "../relay_docker"
    destination = "/root/docker"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "docker pull ethereum/client-go",
      "git clone https://github.com/polyswarm/relay.git"
    ]

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }
}

resource "digitalocean_volume" "relay2" {
  region      = "${var.region}"
  name        = "relay2"
  size        = 300
  description = "Holds the geth data"
}

resource "digitalocean_droplet" "relay2" {
  image    = "docker"
  name     = "relay1"
  region   = "${var.region}"
  size     = "s-2vcpu-4gb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  tags     = ["${digitalocean_tag.relay.id}"]
  volume_ids = ["${digitalocean_volume.relay2.id}"]

  provisioner "file" {
    source = "../relay2"
    destination = "/root/keystore"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "file" {
    source = "../relay_docker"
    destination = "/root/docker"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "docker pull ethereum/client-go",
      "git clone https://github.com/polyswarm/relay.git"
    ]

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }
}

resource "digitalocean_volume" "relay3" {
  region      = "${var.region}"
  name        = "relay3"
  size        = 300
  description = "Holds the geth data"
}

resource "digitalocean_droplet" "relay3" {
  image    = "docker"
  name     = "relay3"
  region   = "${var.region}"
  size     = "s-2vcpu-4gb"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  tags     = ["${digitalocean_tag.relay.id}"]
  volume_ids = ["${digitalocean_volume.relay3.id}"]

  provisioner "file" {
    source = "../bootnode"
    destination = "/root/bootnode"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "file" {
    source = "../relay3"
    destination = "/root/keystore"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "file" {
    source = "../relay_docker"
    destination = "/root/docker"

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "docker pull ethereum/client-go",
      "git clone https://github.com/polyswarm/relay.git"
    ]

    connection = {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }
}

# All of these should be accessible only by geth or ssh
resource "digitalocean_firewall" "sidechain" {
  name = "sidechain"
  droplet_ids = [
    "${digitalocean_droplet.relay1.id}",
    "${digitalocean_droplet.relay2.id}",
    "${digitalocean_droplet.relay3.id}",
    "${digitalocean_droplet.bootnode.id}",
    "${digitalocean_droplet.sealer1.id}",
    "${digitalocean_droplet.sealer2.id}",
    "${digitalocean_droplet.sealer3.id}"
  ]

  # permit inbound from hive-internal and hive-ssh-hop
  inbound_rule = [
    {
      protocol    = "tcp"
      port_range  = "22"
    },
    {
      protocol    = "tcp"
      port_range  = "30301"
    },
    {
      protocol    = "tcp"
      port_range  = "30303"
    },
    {
      protocol    = "udp"
      port_range  = "30301"
    },
    {
      protocol    = "udp"
      port_range  = "30303"
    },
  ]

  outbound_rule = [
    {
      protocol    = "tcp"
      port_range  = "30301"
    },
    {
      protocol    = "tcp"
      port_range  = "30303"
    },
    {
      protocol    = "udp"
      port_range  = "30301"
    },
    {
      protocol    = "udp"
      port_range  = "30303"
    },
  ]
}

resource "digitalocean_record" "bootnode" {
  domain = "polyswarm.network"
  type   = "A"
  name   = "bootnode"
  value  = "${digitalocean_droplet.bootnode.ipv4_address}"
}

output "ip-bootnode" {
  value = "${digitalocean_droplet.bootnode.ipv4_address}"
}

output "ip-relay1" {
  value = "${digitalocean_droplet.relay1.ipv4_address}"
}

output "ip-relay2" {
  value = "${digitalocean_droplet.relay2.ipv4_address}"
}

output "ip-relay3" {
  value = "${digitalocean_droplet.relay3.ipv4_address}"
}