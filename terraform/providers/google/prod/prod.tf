variable "project"		{}
variable "region"		{}
variable "credentials"		{}
variable "atlas_username"	{}
variable "atlas_environment"	{}
variable "image"		{}

variable "name"			{}
variable "cidr"			{}

provider "google" {
  credentials = "${var.credentials}"
  project     = "${var.project}"
  region      = "${var.region}"
}

atlas {
  name = "${var.atlas_username}/${var.atlas_environment}"
}

module "network" {
  source = "../../../modules/google/network"

  name = "${var.name}"
  region = "${var.region}"
  cidr = "${var.cidr}"
}

resource "google_compute_instance" "default" {
  name         = "${var.name}-test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  disk {
    image = "${var.image}"
  }

  // Local SSD disk
  disk {
    type    = "local-ssd"
    scratch = true
  }

  network_interface {
    # network = "${module.network.name}"
    subnetwork = "${module.network.subnetwork_name}"

    access_config {
    }
  }
}
