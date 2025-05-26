output "network_name" {
  value = data.google_compute_network.vpc_network.name
}

output "subnetworks_names" {
  value = data.google_compute_subnetwork.subnetwork
}
