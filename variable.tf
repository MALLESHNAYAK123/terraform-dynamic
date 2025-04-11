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