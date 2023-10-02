variable "path" {default = "C:/Users/chawl/Projects/Sandbox/Terraform_Sandbox/credentials"}

provider "google" {
    project = "123-test-project"
    region = "asia-south2"
    credentials = "${file("${var.path}/secrets.json")}"
}