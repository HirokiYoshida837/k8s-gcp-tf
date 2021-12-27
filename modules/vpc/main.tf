resource "google_compute_network" "vpc_network" {
  name                    = "k8s-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "k8s-nodes"
  ip_cidr_range = "10.240.0.0/24"
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "vpc_subnet_ansible" {
  name          = "k8s-maintenance"
  ip_cidr_range = "10.240.10.0/24"
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_firewall" "allow_internal" {
  name    = "k8s-allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "ipip"
  }

  source_ranges = [
    google_compute_subnetwork.vpc_subnet.ip_cidr_range
  ]
}

resource "google_compute_firewall" "allow_maintenance" {
  name    = "k8s-allow-maintenance"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "ipip"
  }

  source_ranges = [
    google_compute_subnetwork.vpc_subnet_ansible.ip_cidr_range
  ]
}

resource "google_compute_firewall" "allow_external" {
  name    = "k8s-allow-external"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    # port 6443 is listened by kube-apiserver
    ports = ["22", "6443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "0.0.0.0/0"
  ]
}

resource "google_compute_firewall" "allow_http" {
  name    = "k8s-allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  target_tags = [
    "http-server"
  ]

  source_ranges = [
    "0.0.0.0/0"
  ]
}

resource "google_compute_firewall" "allow_https" {
  name    = "k8s-allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports = ["443"]
  }
  
  target_tags = [
    "https-server"
  ]

  source_ranges = [
    "0.0.0.0/0"
  ]
}


output "vpc_network_out" {
  value = google_compute_network.vpc_network.name
}

output "vpc_subnet_out" {
  value = google_compute_subnetwork.vpc_subnet.name
}

output "vpc_subnet_maintenance_out" {
  value = google_compute_subnetwork.vpc_subnet_ansible.name
}
