#####EJERCICIO BONUS#####


#resource "google_project_iam_binding" "dar_permiso" {
#  project = var.project
#  role    = "roles/viewer"
#
#  members = [
#    "user:javioreto@gmail.com"
#  ]
#}
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.32.0"
    }
  }
}

provider "google" {
  credentials = file("cred.json")

  project = var.project
  region = var.region 
  zone = var.zone 
}

resource "google_compute_network" "vpc_network" {
  name = var.nombrered
}


resource "random_string" "texto" {
  length = var.randomlength
  special = false
  upper = false
}
resource "google_storage_bucket" "mi_bucket" {
  name = "my_bucket${random_string.texto.result}"
  location = var.region
}

resource "google_compute_address" "ip_estatica" {
    name = var.ipestatica
  
}

resource "google_compute_instance" "nombre_istancia" {
    depends_on = [
      google_compute_network.vpc_network, google_compute_address.ip_estatica
    ]
    name = var.nombreistancia
    machine_type = var.machinetype
    tags = ["web", "dev"]

    boot_disk {
      initialize_params {
        image = "projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20220824"
        #TIP: compute engine > rest equivalent y tomamos el enlace de selflink no el de licenses
      }
    }
    network_interface {
      network = google_compute_network.vpc_network.name
        access_config {
            nat_ip = google_compute_address.ip_estatica.address
        }
    }
  
}