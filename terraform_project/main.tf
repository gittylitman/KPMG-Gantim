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

module "proxy_subnet" {
  source = "../modules/proxy-subnet"

  subnet_name = "proxy-snet"
  region = var.location
  ip_range = "10.3.0.0/28"
  network_id = module.network.network_id
}

module "load_balancer" {
  source = "../modules/load-balancer"

  region = var.location
  vpc_name = module.network.network_name
  subnet_name = module.proxy_subnet.proxy_subnet_name
  cloud_run_name =  [ "admin-cr", "citizen-cr" ]
  certificate_name = "certificate-gantim"
  http_proxy_name = "internal-https-proxy"
  https_forwarding_rule_name = "https-forwarding-rule"
  ip_range = "10.2.0.0/28"
  backend_snet_name = "snet-back"
  network_id = module.network.network_id

  
}
