terraform {
  backend "gcs" {
    bucket  = "terraform-gantim"
    prefix  = "state"
  }
}

module "network" {
  source = "../modules/network"

  vpc_name = "gantim"
  subnetwork_name = "snet-gantim"
  region = var.location
  ip_cidr_range = "10.1.0.0/28"

}

module "load_balancer" {
  source = "../modules/load-balancer"

  region = var.location
  vpc_name = module.network.network_name
  subnet_name = module.network.subnet_name
  cloud_run_name =  [ "cloud-run-admin-neg", "cloud-run-citizen-neg" ]
  certificate_name = "certificate-gantim"
  http_proxy_name = "internal-https-proxy"
  https_forwarding_rule_name = "https_forwarding_rule"
}
