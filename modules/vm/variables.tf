# currentのvariablesから渡すので、ここは内容は空でOK。

variable "project" {}
variable "zone" {}

variable "vpc_name" {}
variable "vpc_subnet_name" {}
variable "vpc_subnet_maintenance_name" {}

variable "disk_image" {
  default = "projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20211115"
}
