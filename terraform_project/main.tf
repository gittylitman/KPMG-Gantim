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
  subnet_name = "proxy-subnet"
  cloud_run_name =  [ "admin-cr", "citizen-cr" ]
  certificate_name = "certificate-gantim"
  http_proxy_name = "internal-https-proxy"
  https_forwarding_rule_name = "https-forwarding-rule"
  network_id = module.network.network_id
  ip_range = "10.3.0.0/26"
  subnet_private_name = module.network.subnet_name
  cert_file = "./certificate.pem"
  private_key_file = "./private_key.pem"
}
