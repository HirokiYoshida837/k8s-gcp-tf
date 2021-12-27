# project metadata
resource "google_compute_project_metadata" "default" {
  metadata = {
    enable-oslogin = "TRUE"
  }
}

# k8s-controller
resource "google_compute_instance" "controller" {
  name         = "controller"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = var.disk_image
      size  = "20"
      type  = "pd-standard"
    }
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  can_ip_forward = true

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.vpc_subnet_name
    network_ip = "10.240.0.11"
    access_config {
    }
  }

  metadata = {
    "block-project-ssh-keys" = "true"
  }
  tags     = ["example-k8s", "controller", "terraform"]
}

# k8s-worker
resource "google_compute_instance" "worker-1" {
  name         = "worker-1"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = var.disk_image
      size  = "20"
      type  = "pd-standard"
    }
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  can_ip_forward = true

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.vpc_subnet_name
    network_ip = "10.240.0.21"
    access_config {
    }
  }

  metadata = {
    "block-project-ssh-keys" = "true"
  }

  tags = ["example-k8s", "worker", "terraform"]

}


# k8s-cluster-provisioning-ansible
# ansible用のホストは別Subnetに置く
resource "google_compute_instance" "ansible-host" {
  name         = "ansible-host"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = var.disk_image
      size  = "20"
      type  = "pd-standard"
    }
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  can_ip_forward = true

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.vpc_subnet_maintenance_name
    network_ip = "10.240.10.31"
    access_config {
    }
  }

  # 作業のため、ansible用hostに VSCode Remote SSHで入りたいので鍵を設定しておいたら便利か？

  tags = ["example-k8s", "ansible", "terraform"]
}
