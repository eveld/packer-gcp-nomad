variable "project_id" {
  type    = string
  default = ""
}

variable "source_image" {
  type = string
  default = "ubuntu-2004-lts"
}

variable "image_name" {
  type = string
  default = "nomad"
}

variable "zone" {
  type = string
  default = "europe-west1-b"
}

variable "nomad_version" {
  type = string
  default = ""
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "googlecompute" "nomad" {
  image_labels = {
    created = local.timestamp
  }

  image_name          = var.image_name
  project_id          = var.project_id
  source_image_family = var.source_image
  ssh_username        = "root"
  zone                = var.zone
}

build {
  sources = ["source.googlecompute.nomad"]

  provisioner "file" {
    destination = "/tmp/resources"
    source      = "resources"
  }

  provisioner "shell" {
    script = "bootstrap.sh"

    environment_vars = ["NOMAD_VERSION=${var.nomad_version}"]
  }
}
