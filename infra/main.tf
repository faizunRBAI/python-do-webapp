# Look up the platform-managed SSH key (uploaded as "udap-<project>" at cloud-prepare)
data "digitalocean_ssh_key" "main" {
  name = "udap-${var.project_name}"
}

# Droplet
resource "digitalocean_droplet" "web" {
  name     = "${var.project_name}-web"
  region   = var.region
  size     = var.droplet_size
  image    = "ubuntu-22-04-x64"
  ssh_keys = [data.digitalocean_ssh_key.main.fingerprint]

  tags = ["${var.project_name}", "udap", "web"]
}

# Reserved IP for a stable public address
resource "digitalocean_reserved_ip" "web" {
  region = var.region
}

resource "digitalocean_reserved_ip_assignment" "web" {
  ip_address = digitalocean_reserved_ip.web.ip_address
  droplet_id = digitalocean_droplet.web.id
}

# Firewall: allow SSH (22) and HTTP (80/443) inbound; all outbound
resource "digitalocean_firewall" "web" {
  name = "${var.project_name}-fw"

  droplet_ids = [digitalocean_droplet.web.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
