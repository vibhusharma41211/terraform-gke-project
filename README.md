# Terraform GKE Infrastructure Deployment

## Overview

This project provisions a **private Google Kubernetes Engine (GKE) cluster** on **Google Cloud Platform (GCP)** using **Terraform**. It also includes **GitHub Actions** workflows to automate infrastructure deployment and destruction.

The infrastructure is built following Infrastructure as Code (IaC) principles, making it reproducible, version-controlled, and easy to manage.

---

## Architecture

The Terraform configuration creates the following resources:

* Custom VPC Network
* Custom Subnet
* Secondary IP Ranges for Pods and Services
* Internal Firewall Rule
* Cloud Router
* Cloud NAT
* Private GKE Cluster
* Managed Node Pool

```
                    Google Cloud Project
                             │
                     Custom VPC Network
                             │
                    Custom Subnet
                             │
        ┌────────────────────┴────────────────────┐
        │                                         │
  Secondary Range                          Secondary Range
      (Pods)                                 (Services)
        │                                         │
        └────────────────────┬────────────────────┘
                             │
                    Private GKE Cluster
                             │
                    Managed Node Pool
                             │
                    Kubernetes Workloads
```

---

## Project Structure

```
terraform-gke-project/
│
├── backend.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
│
├── .github/
│   └── workflows/
│       ├── terraform-deploy.yml
│       └── terraform-destroy.yml
│
├── .gitignore
└── README.md
```

---

## Prerequisites

Before using this project, ensure you have:

* Google Cloud Project
* Billing enabled
* Terraform (v1.5 or later)
* Google Cloud SDK
* Git
* GitHub Account
* Required GCP APIs enabled:

  * Kubernetes Engine API
  * Compute Engine API
  * Cloud Resource Manager API
  * IAM API

---

## GCP Resources Created

| Resource        | Description                       |
| --------------- | --------------------------------- |
| VPC             | Custom Virtual Private Cloud      |
| Subnet          | Custom subnet with primary CIDR   |
| Secondary Range | Pod IP allocation                 |
| Secondary Range | Service IP allocation             |
| Firewall        | Internal communication            |
| Cloud Router    | Required for Cloud NAT            |
| Cloud NAT       | Internet access for private nodes |
| GKE Cluster     | Private Kubernetes Cluster        |
| Node Pool       | Managed worker nodes              |

---

## Deployment

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Generate an execution plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

---

## Destroy Infrastructure

To remove all created resources:

```bash
terraform destroy
```

Or use the GitHub Actions **Terraform Destroy** workflow.

---

## GitHub Actions

### Deploy Workflow

Runs automatically when code is pushed to the **main** branch.

Pipeline:

```
Checkout Repository
        ↓
Authenticate to GCP
        ↓
Terraform Init
        ↓
Terraform Validate
        ↓
Terraform Plan
        ↓
Terraform Apply
```

---

### Destroy Workflow

Runs **only** when manually triggered from the GitHub Actions page.

Pipeline:

```
Checkout Repository
        ↓
Authenticate to GCP
        ↓
Terraform Init
        ↓
Terraform Destroy
```

---

## Remote State

Terraform state is stored in a Google Cloud Storage (GCS) bucket.

Benefits:

* Shared state management
* Team collaboration
* State locking (when configured)
* Version history
* Recovery from accidental changes

---

## Security Features

* Private GKE Cluster
* Private Worker Nodes
* Cloud NAT for outbound internet access
* Custom VPC
* Separate Pod and Service IP ranges
* Infrastructure managed through Terraform
* GitHub Actions for automated deployment

---

## Technologies Used

* Terraform
* Google Cloud Platform (GCP)
* Google Kubernetes Engine (GKE)
* GitHub Actions
* Cloud NAT
* Cloud Router
* VPC Networking
* Infrastructure as Code (IaC)

---

## Future Enhancements

* Remote Terraform Backend using GCS
* Workload Identity Federation
* GitHub Environment Approvals
* Terraform Security Scanning (Checkov / tfsec)
* Terraform Modules
* Monitoring with Cloud Monitoring
* Logging with Cloud Logging
* Kubernetes Application Deployment
* Helm Integration
* CI/CD for Kubernetes Applications

---

## Author

**Vibhu Sharma**

Cloud | DevOps | Terraform | Google Cloud Platform (GCP) | Kubernetes

---

## License

This project is intended for learning, demonstration, and portfolio purposes.
