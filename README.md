# GCP Private Service Connect Terraform examples

**Disclaimer: These examples are not meant as drop-in solutions but solely to demonstrate how Private Service Connect may be implemented using Terraform. 
Some best practices are included, some may not.**

## Structure
1) **Consumer Endpoint** - Contains an example forwarding rule which creates a Private Service Connect Endpoint
2) **Consumer Load Balancer Backend** - Contains an example forwarding rule which creates an Internal Proxy Load Balancer with a PSC Network Endpoint Group backend. 
3) **Producer Service** - An example web application exposed as PSC service using an Internal Load Balancer.

## Deploy samples

### Prerequisites
1) A GCP project with billing enabled
2) IAM Permissions on the GCP project to deploy resources
3) Terraform and gcloud CLI tools installed

### Deployment order
1) Producer service
2) Consumer endpoint / Consumer load balancer

### Deployment steps
1) Navigate to one of the directories
2) Run `terraform init` to prepare the environment
3) Run `terraform plan` to just review the plan
4) Run `terraform apply` to deploy the examples
5) Run `terraform destroy` to clean up after testing
