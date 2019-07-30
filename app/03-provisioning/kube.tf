variable "gce_ssh_user" {
  default = "root"
}
variable "gce_ssh_pub_key_file" {
  default = "~/.ssh/google_compute_engine.pub"
}

variable "gce_zone" {
  type = "string"
}

// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("keys.json")}"
}

resource "google_compute_network" "default" {
  name                    = "rmorilha-kubernetes"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name            = "rmorilha-kubernetes"
  network         = "${google_compute_network.default.name}"
  ip_cidr_range   = "172.16.238.0/24"
}

resource "google_compute_firewall" "internal" {
  name    = "rmorilha-kubernetes-allow-internal"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
  }

  source_ranges = [ "172.16.238.0/24","172.17.0.0/16" ]
}

resource "google_compute_firewall" "external" {
  name    = "rmorilha-kubernetes-allow-external"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

resource "google_compute_address" "default" {
  name = "rmorilha-kubernetes"
}

resource "google_compute_disk" "controller" {
  count = 3
  name  = "controller${count.index}-disk"
  type  = "pd-standard"
  zone  = "${var.gce_zone}"
  size = 80
}

resource "google_compute_instance" "controller" {
  count = 3
  name            = "controller-${count.index}"
  machine_type    = "n1-standard-1"
  zone            = "${var.gce_zone}"
  can_ip_forward  = true

  tags = ["rmorilha-kubernetes","controller"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  attached_disk {
    source = "controller${count.index}-disk"
  }

  // Local SSD disk
//  scratch_disk {
//  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.default.name}"
    network_ip = "172.16.238.1${count.index}"

    access_config {
      // Ephemeral IP
    }
  }
  
  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }

  metadata = {
    sshKeys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  metadata_startup_script = "apt-get install -y python"
}

resource "google_compute_disk" "worker" {
  count = 3
  name  = "worker${count.index}-disk"
  type  = "pd-standard"
  zone  = "${var.gce_zone}"
  size = 80
}

resource "google_compute_instance" "worker" {
  count = 3
  name            = "worker-${count.index}"
  machine_type    = "n1-standard-1"
  zone            = "${var.gce_zone}"
  can_ip_forward  = true

  tags = ["rmorilha-kubernetes","worker"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  attached_disk {
    source = "worker${count.index}-disk"
  }

  // Local SSD disk
  //scratch_disk {
  //}

  network_interface {
    subnetwork = "${google_compute_subnetwork.default.name}"
    network_ip = "172.16.238.2${count.index}"

    access_config {
      // Ephemeral IP
    }
  }
  
  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }

  metadata = {
    pod-cidr = "172.16.${count.index}.0/24"
    sshKeys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  metadata_startup_script = "apt-get install -y python"
}
