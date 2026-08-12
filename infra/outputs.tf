output "droplet_ip" {
  description = "Reserved (stable) public IP of the web droplet"
  value       = digitalocean_reserved_ip.web.ip_address
}

output "droplet_id" {
  description = "Droplet ID"
  value       = digitalocean_droplet.web.id
}
