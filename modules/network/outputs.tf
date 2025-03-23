output "network_id" {
  value = data.google_compute_network.vpc_network.id
}

output "subnet_id" {
  value = data.google_compute_subnetwork.subnetwork[0].id
}

output "subnet_bigquery_id" {
  value = data.google_compute_subnetwork.subnetwork[1].id
}
