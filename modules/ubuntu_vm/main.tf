resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  depends_on = [ google_project_service.compute ]
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
    depends_on = [ time_sleep.wait_60_seconds ]
}
