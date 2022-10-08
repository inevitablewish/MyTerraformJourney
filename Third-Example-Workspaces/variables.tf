variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "ap-southeast-2"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = map(string)
  description = "Base CIDR Block for VPC"

}

variable "vpc_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR Block for Subnets in VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "instance_type" {
  type        = map(string)
  description = "Type for EC2 Instnace"

}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "Globomantics"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}

variable "billing_code" {
  type        = string
  description = "Billing code for resource tagging"
}

variable "vpc_subnet_count" {
  type        = map(number)
  description = "Number of Subnets to create"

}

variable "instance_count" {
  type        = map (number)
  description = "Number of Instances to create"
 
}

variable "naming_prefix" {
  type        = string
  description = "Naming Prefix for all Resources"
  default     = "MOHSIN"
}

variable "instance_name" {
  type        = string
  description = "Naming the AWS EC2 Instances"
  default     = "Nginx"
}