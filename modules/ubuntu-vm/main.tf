resource "google_service_account" "vm_instance_service_account" {
  account_id   = var.service_account_vm_name
  display_name = "Custom SA for VM Instance"
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
      network = var.network
    }
    service_account {
      email = google_service_account.vm_instance_service_account.email
      scopes = ["cloud-platform"]
    }
}
