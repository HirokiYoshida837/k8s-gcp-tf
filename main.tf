terraform {
  # チュートリアルなのでローカルにtfstateを保存。実施はRemoteに保存したほうがいい。
  # tfstateの中に鍵の情報などが含まれるので、git等に公開しないよう注意。
  backend "local" {
    path = "./backends/terraform.tfstate"
  }

  # secret managerを使うので古いバージョンだと動かない。
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.3.0"
    }
  }
}


provider "google" {
  # terraformによるプロビジョニングの権限が与えられたServie Accountの鍵を指定。git等に公開しないように注意。
  credentials = file("./credentials/credential.json")

  project = var.project
  region  = var.region
  zone    = var.zone
}

# Compute Engine
module "vm" {
  source = "./modules/vm"

  project = var.project
  zone    = var.zone

  # vpc側のモジュールでoutputした変数をここから渡す。
  vpc_name                    = module.vpc.vpc_network_out
  vpc_subnet_name             = module.vpc.vpc_subnet_out
  vpc_subnet_maintenance_name = module.vpc.vpc_subnet_maintenance_out
}


# VPC Network
module "vpc" {
  source = "./modules/vpc"

  project = var.project
  zone    = var.zone
}

# IAM
module "iam" {
  source  = "./modules/iam"
  project = var.project
}
