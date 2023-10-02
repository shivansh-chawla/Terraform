resource "google_compute_instance" "test_resource1" {
    count = length(var.instance_count)
    name = "list1-${count.index+1}"
    zone = "asia-south-1a"
    machine_type = var.machine_type["dev"]
    description = "This is a test virtual machine"

      tags = [] #firewall

    boot_disk {
      initialize_params {
        image = var.environment == "production" ? var.image : var.imagedev
        size = "20"
      }
      
    }

    labels = {
      name = "list1-${count.index+1}"
      machine_type = var.machine_type["dev"]
    }

    network_interface {
      network = "default"
    }

    service_account {
      scopes = ["test-account", "service-account-test"]
    }
}

resource "google_compute_disk" "ssd-25" {
  name = "test_disk"
  zone = "asia-south-1a"
  type = "pd-disk"
  size = "25"
}

resource "google_storage_bucket" "test-bucket" {
  name = "test-bucket-8753458"
  location = "asia-south-1a"
  storage_class = "regional"

  labels = {
    name = "test-bucket-8753458"
    zone = "asia-south-1a"
  }

  uniform_bucket_level_access = true   #set to false by default

  versioning {
    enabled = false
  }
}

resource google_storage_bucket_object "test-pic" {
  name = "test-pic"
  bucket = "google_storage_bucket.test-bucket.name"
  source = "test-pic.png"
}

resource "google_compute_instance" "test_resource2" {
    count = "1"
    name = "first"
    zone = "asia-south-1a"
    machine_type = var.machine_type["dev"]

    boot_disk {
      initialize_params {
        image = var.image
      }
      
    }

    network_interface {
      network = "default"
    }

    service_account {
      scopes = ["test-account", "service-account-test"]
    }

    depends_on = [ google_compute_instance.test_resource1 ]
}

resource "google_compute_attached_disk" "ssd-25-test-resource_2" {
  disk = "google_compute_disk.ssd-25.self_link"
  instance = "google_compute_instance.test_resource2.self_link"
}

output "name" { value = "${google_compute_instance.test_resource1.*.name}"}

output "machine_zone" { value = "${google_compute_instance.test_resource2.*.zone}"}

output "machine_type" {value = "${google_compute_instance.test_resource1.*.machine_type}"}

#output "instance_ids" { value = join(",",google_compute_instance.test_resource.*.id)}