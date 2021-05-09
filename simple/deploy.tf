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

resource "google_compute_instance" "DZ_DevOps14_Simple" {
  name         = "dz-devops14"
#  machine_type = "e2-small" // 2vCPU, 2GB RAM
  machine_type = "e2-medium" // 2vCPU, 4GB RAM
  tags = ["http-server","https-server"]
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      size = "10" 
      type = "pd-balanced" // pd-standard, pd-balanced, pd-ssd
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
    ]
    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("/root/.ssh/id_rsa")
      host        = self.network_interface[0].network_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt install default-jre -y",
      "sudo apt install mc -y",
      "sudo apt install nginx -y",
      "sudo apt install tomcat9 -y",
    ]
    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("/root/.ssh/id_rsa")
      host        = self.network_interface[0].network_ip
    }
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("/root/.ssh/id_rsa")
      host        = self.network_interface[0].network_ip
    }
  }

  provisioner "file" {
    source      = "Puzzle15.war"
    destination = "/var/lib/tomcat9/webapps/Puzzle15.war"
    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("/root/.ssh/id_rsa")
      host        = self.network_interface[0].network_ip
    }
  }
}