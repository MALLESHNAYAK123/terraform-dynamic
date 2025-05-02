variable "vpc_cidr" {
  description = "cidr for vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "nayak"
}

variable "az" {
  description = "List of availability zones"
  type        = list(string)
  default     = []
}

variable "my-sg" {
  description = "Name of the security group"
  type        = string
  default     = "nayak"
}

variable "ingress_ports" {
  description = "List of ingress ports to allow"
  type        = list(number)
  default     = [22, 80, 443, 8080]
}