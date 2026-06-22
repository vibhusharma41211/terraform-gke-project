resource "google_compute_network" "vpc_network" {
  name                    = "vibs-gke-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnet" {
  name          = "vibs-gke-subnet"
  region        = "us-east4"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.50.0.0/24"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.60.0.0/20"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.70.0.0/24"
  }
}

resource "google_compute_firewall" "allow-internal" {
  name    = "internal-firewall"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "all"
  }

  source_ranges = ["10.50.0.0/24", "10.60.0.0/20", "10.70.0.0/24"]
}

resource "google_compute_router" "router" {
  name    = "vibs-gke-router"
  region  = "us-east4"
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "vibs-gke-cloud-nat"
  router                             = google_compute_router.router.name
  region                             = "us-east4"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_container_cluster" "primary" {

  name                     = "vibs-gke-cluster"
  location                 = "us-east4"
  network                  = google_compute_network.vpc_network.id
  subnetwork               = google_compute_subnetwork.subnet.id
  remove_default_node_pool = true
  initial_node_count       = 1
  networking_mode          = "VPC_NATIVE"

  ip_allocation_policy {

    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {

    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  deletion_protection = false
}

resource "google_container_node_pool" "primary_node" {

  name       = "vibs-node-pool-1"
  cluster    = google_container_cluster.primary.name
  location   = "us-east4"
  node_count = 2

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {

    machine_type = "e2-medium"
    image_type   = "ubuntu_containerd"
    disk_size_gb = 10
    disk_type    = "pd-standard"
  }
}
