provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_tag" "bootnode" {
  name = "bootnode"
}

resource "digitalocean_tag" "sidechain" {
  name = "sidechain"
}

resource "digitalocean_tag" "relays" {
  name = "relays"
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

# TODO: a single droplet for everything but the SSH hop. we should decompose this.
# resource "digitalocean_droplet" "relay-1" {
#   image    = "docker"
#   name     = "relay-1"
#   region   = "${var.region}"
#   size     = "s-1vcpu-2gb"
#   ssh_keys = ["${digitalocean_ssh_key.default.id}"]
#   tags     = ["${digitalocean_tag.relays.id}"]

#   provisioner "file" {
#     source      = "../bootnode"
#     destination = "/root/bootnode"

#     connection = {
#       type        = "ssh"
#       user        = "root"
#       private_key = "${file("${var.private_key_path}")}"
#       agent       = false
#     }
#   }

#   provisioner "file" {
#     source      = "./relay/1"
#     destination = "/root/relay"

#     connection = {
#       type        = "ssh"
#       user        = "root"
#       private_key = "${file("${var.private_key_path}")}"
#       agent       = false
#     }
#   }

#   provisioner "remove-exec" {
#     inline = [
#       "curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose",
#       "chmod +x /usr/local/bin/docker-compose",
#       "ENODE=$(bootnode --nodekey --writeaddress)",
#       "ENODE_IP=${digitalocean_droplet.bootnode.ipv4_address}",
#       "pushd relay",
#       "docker-compose -f docker/relay.yml up -d"
#     ]

#     connection = {
#       type        = "ssh"
#       user        = "root"
#       private_key = "${file("${var.private_key_path}")}"
#       agent       = false
#     }
#   }
# }

# # NOTE: effectively treat protocol and port_range as required due to bugs in DO's API
# resource "digitalocean_firewall" "hive-internal" {
#   # permit comms among "hive-ssh-hop" and "hive-internal" groups

#   name = "hive-internal-only"

#   droplet_ids = ["${digitalocean_droplet.meta.id}"]

#   # permit inbound from hive-internal and hive-ssh-hop
#   inbound_rule = [
#     {
#       protocol    = "tcp"
#       port_range  = "22"
#       source_tags = ["hive-internal", "hive-ssh-hop"]
#     },
#     {
#       protocol    = "tcp"
#       port_range  = "31337"
#       source_tags = ["hive-internal", "hive-ssh-hop"]
#     },
#     {
#       protocol    = "tcp"
#       port_range  = "1-65535"
#       source_tags = ["hive-internal"]
#     },
#   ]

#   # permit outbound to hive-internal
#   outbound_rule = [
#     {
#       protocol         = "tcp"
#       port_range       = "1-65535"
#       destination_tags = ["hive-internal"]
#     },
#     {
#       protocol         = "udp"
#       port_range       = "1-65535"
#       destination_tags = ["hive-internal"]
#     },
#   ]
# }

# resource "digitalocean_firewall" "hive-ssh-hop" {
#   name        = "only-ssh-in-dns-out"
#   droplet_ids = ["${digitalocean_droplet.ssh-hop.id}"]

#   # permit inbound SSH from *
#   inbound_rule = [
#     {
#       protocol         = "tcp"
#       port_range       = "${var.port-ssh}"
#       source_addresses = ["0.0.0.0/0"]
#     },
#   ]

#   # permit outbound DNS to * (TODO: do we need this)add
#   # permit outbound all to hive-internal
#   outbound_rule = [
#     {
#       protocol              = "tcp"
#       port_range            = "${var.port-dns}"
#       destination_addresses = ["0.0.0.0/0"]
#     },
#     {
#       protocol              = "udp"
#       port_range            = "${var.port-dns}"
#       destination_addresses = ["0.0.0.0/0"]
#     },
#     {
#       # permit all outbound to "hive-internal" (not other ssh hops)
#       protocol         = "tcp"
#       port_range       = "1-65535"
#       destination_tags = ["hive-internal"]
#     },
#     {
#       protocol         = "udp"
#       port_range       = "1-65535"
#       destination_tags = ["hive-internal"]
#     },
#     {
#       # permit all outbound to "hive-internal" (not other ssh hops)
#       protocol              = "tcp"
#       port_range            = "1-65535"
#       destination_addresses = ["${digitalocean_floating_ip.meta.ip_address}"]
#     },
#     {
#       protocol              = "udp"
#       port_range            = "1-65535"
#       destination_addresses = ["${digitalocean_floating_ip.meta.ip_address}"]
#     },
#   ]
# }

resource "digitalocean_record" "bootnode" {
  domain = "polyswarm.network"
  type   = "A"
  name   = "bootnode"
  value  = "${digitalocean_droplet.bootnode.ipv4_address}"
}

output "ip-bootnode" {
  value = "${digitalocean_droplet.bootnode.ipv4_address}"
}
