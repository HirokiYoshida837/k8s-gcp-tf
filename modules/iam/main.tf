# service account
resource "google_service_account" "ansible_provision_account" {
  account_id   = "ansible-provision"
  display_name = "ansible-provision"
  description  = "service account for provisioning k8s cluster with ansible."
}

# terraformで使用するService Accountに `Project IAM 管理者` がなければ、IAMの作成ができないので注意。強い権限なので本番等ではやらないほうがいいかも。
locals {
  apply_roles = {
    "iam_osAdminLogin"       = "roles/compute.osAdminLogin"
    "iam_instanceAdmin_v1"   = "roles/compute.instanceAdmin.v1"
    "iam_instanceAdmin"      = "roles/compute.instanceAdmin"
    "iam_serviceAccountUser" = "roles/iam.serviceAccountUser"
  }
}

resource "google_project_iam_member" "iams" {
  project  = var.project
  for_each = local.apply_roles
  role     = each.value
  member   = "serviceAccount:${google_service_account.ansible_provision_account.email}"
}

resource "google_service_account_key" "my_key" {
  service_account_id = google_service_account.ansible_provision_account.name
}

resource "google_secret_manager_secret_version" "secret" {
  secret      = google_secret_manager_secret.secret-basic.id
  secret_data = base64decode(google_service_account_key.my_key.private_key)
}

resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret"

  labels = {
    label = "ansible-sa-secret"
  }

  replication {
    automatic = true
  }
}

