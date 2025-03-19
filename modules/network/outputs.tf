output "network_name" {
  value = data.google_compute_network.vpc_network.name
}

output "subnet_name" {
  value = data.google_compute_subnetwork.subnetwork[0].name
}

output "subnet_bigquery_name" {
  value = data.google_compute_subnetwork.subnetwork[1].name
}

output "network_id" {
  value = data.google_compute_network.vpc_network.id
}