######################################################
# Input Variables for Only Public Subnets VPC for EKS
######################################################

variable "region" {
  type        = string
  description = "AWS region"
}

variable "name" {
  type        = string
  description = "Name prefix for resources"
  default     = "eks-sample"
}

variable "vpc_cidr" {
  type        = string
  default     = "192.168.0.0/16"
  description = "The CIDR range for the VPC"
}

variable "public_subnet_1_cidr" {
  type    = string
  default = "192.168.0.0/18"
}

variable "public_subnet_2_cidr" {
  type    = string
  default = "192.168.64.0/18"
}

variable "private_subnet_1_cidr" {
  type    = string
  default = "192.168.128.0/18"
}

variable "private_subnet_2_cidr" {
  type    = string
  default = "192.168.192.0/18"
}
