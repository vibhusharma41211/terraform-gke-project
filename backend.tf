terraform {
  backend "gcs" {
    bucket = "vibs-terraform-state"
    prefix = "gke"
  }
}