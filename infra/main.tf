# ── SSH Key (platform-managed, account-scoped) ──────────────────────────────
data "digitalocean_ssh_key" "main" {
  name = "udap-${var.project_name}"
}

# ── Droplet ──────────────────────────────────────────────────────────────────
resource "digitalocean_droplet" "app" {
  name      = "${var.project_name}-web"
  region    = var.region
  size      = var.droplet_size
  image     = "ubuntu-22-04-x64"
  ssh_keys  = [data.digitalocean_ssh_key.main.fingerprint]

  tags = [
    "project:${var.project_name}",
    "managed-by:udap"
  ]
}

# ── Firewall ─────────────────────────────────────────────────────────────────
resource "digitalocean_firewall" "app" {
  name    = "${var.project_name}-fw"
  droplet_ids = [digitalocean_droplet.app.id]

  # Inbound
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

  # Outbound (allow all)
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
