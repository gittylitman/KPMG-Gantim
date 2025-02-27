resource "google_project_service" "iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "vm_instance_service_account" {
  account_id   = var.service_account_vm_name
  display_name = "Custom SA for VM Instance"
  depends_on = [ google_project_service.iam ]
}

resource "google_compute_instance" "ubuntu_vm"{
    name = var.vm_name
    machine_type = var.machine_type
    zone = var.zone
    
    boot_disk {
      initialize_params {
        image = var.image
      }
    }

    network_interface {
      network = var.network_name
      subnetwork = var.subnetwork_name
    }

    metadata_startup_script = <<-EOT
      #!/bin/bash
      sudo apt update && sudo apt upgrade -y
      sudo apt install -y ubuntu-gnome-desktop
    EOT

    service_account {
      email = google_service_account.vm_instance_service_account.email
      scopes = ["cloud-platform"]
    }
}

resource "google_compute_firewall" "rules" {
  name        = "my-firewall-rule"
  network     = var.network_name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["22", "8080", "1000-2000"]
  }
  source_service_accounts = [google_service_account.vm_instance_service_account.account_id]
}
