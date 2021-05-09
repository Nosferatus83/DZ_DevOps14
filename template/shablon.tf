terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.66.1"
    }
  }
}

provider "google" {
  project     = "cosmic-reserve-307720"
  region      = "europe-west3"
  zone      = "europe-west3-a"
}


resource "google_compute_instance" "DZ_Template_VM" {
  count=var.kol
  name         = "vm-${count.index + 1}"
  machine_type = "custom-${var.cpu}-${var.ram*1024}-ext" // custom-NUMBER_OF_CPUS-AMOUNT_OF_MEMORY_MB 2vCPU, 15GB RAM / 6.5GB RAM per CPU, if needed more + -ext
  
  tags = ["http-server","https-server"]
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      size = "10" // size in GB for Disk
      type = "pd-balanced" // Available options: pd-standard, pd-balanced, pd-ssd
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP and external static IP
      #nat_ip = google_compute_address.static.address
    }
  }

  metadata = {
    ssh-keys = "root:${file("/root/.ssh/id_rsa.pub")}" // Point to ssh public key for user root
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install mc -y",
    ]
    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("/root/.ssh/id_rsa")
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }
}