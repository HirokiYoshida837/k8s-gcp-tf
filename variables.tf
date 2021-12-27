variable "project" {
  type        = string
  default     = "k8s-test-334111"
  description = "GCP project id"
}

variable "region" {
  type        = string
  default     = "asia-northeast1"
  description = "default region"
}

variable "zone" {
  type    = string
  default = "asia-northeast1-a"
}
