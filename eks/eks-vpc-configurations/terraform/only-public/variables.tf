################################################
# Variables for Only Public Subnets for EKS
################################################

variable "region" {
  type        = string
  description = "AWS region"
}

variable "name" {
  type        = string
  description = "Name prefix for resources"
  default     = "eks-public-only"
}

variable "vpc_cidr" {
  type        = string
  default     = "192.168.0.0/16"
  description = "The CIDR range for the VPC"
}

variable "subnet_01_cidr" {
  type        = string
  default     = "192.168.64.0/18"
  description = "CIDR for Subnet01"
}

variable "subnet_02_cidr" {
  type        = string
  default     = "192.168.128.0/18"
  description = "CIDR for Subnet02"
}

variable "subnet_03_cidr" {
  type        = string
  default     = "192.168.192.0/18"
  description = "CIDR for Subnet03 (only if region has > 2 AZs)"
}
