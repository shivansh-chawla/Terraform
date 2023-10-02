variable "image" {default = "ubuntu"}

variable "imagedev" {default = "ubuntu-lts" }

variable "environment" {default = "production"}

variable "machine_type" {
    type = map(string)
    default = {
        "dev" = "n1-standard-1"
        "prod" = "n1-standard-2"
    }
}

variable "instance_count" { default = ["server-1","server-2","server-3"]}