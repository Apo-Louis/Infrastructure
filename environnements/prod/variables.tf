
### --- VPC --- ###

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "fil-rouge-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  description = "The AWS region to deploy the infrastructure"
  type        = string
  default     = "eu-west-3"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
  }

variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "CIDR blocks for the master nodes"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "database_subnets" {
  description = "CIDR blocks for the master nodes"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}
# ---------------------------------------------#

### ---- EKS ---- ###

variable "eks_cluster_name" {
  description = "k8s cluster_name"
  type        = string
  default = "eks-cluster"
}


### --- CERT-MANAGER --- ###

variable "ovh_application_key" {
  description = "OVH application key"
  type        = string
}

variable "ovh_application_secret" {
  description = "OVH application secret"
  type        = string
}

variable "ovh_consumer_key" {
  description = "OVH consumer key"
  type        = string
}