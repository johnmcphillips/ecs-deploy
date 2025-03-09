### Start Global Variables ###
variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "Provisioned by Terraform"
}
### End Global Variables ###

### Start VPC Variables ###
variable "vpc_name" {
  default = "ecs-vpc"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "PublicSubnet01" {
  description = "PublicSubnet01 Data"
  type        = map(string)
  default = {
    "name"       = "PublicSubnet01"
    "cidr_block" = "10.0.100.0/24"
  }
}

variable "PublicSubnet02" {
  description = "PublicSubnet02 Data"
  type        = map(string)

  default = {
    "name"       = "PublicSubnet02"
    "cidr_block" = "10.0.101.0/24"
  }
}
variable "PrivateSubnet01" {
  description = "PrivateSubnet01 Data"
  type        = map(string)
  default = {
    "name"       = "PrivateSubnet01"
    "cidr_block" = "10.0.1.0/24"
  }
}

variable "PrivateSubnet02" {
  description = "PrivateSubnet02 Data"
  type        = map(string)
  default = {
    "name"       = "PrivateSubnet02"
    "cidr_block" = "10.0.2.0/24"
  }
}
### End VPC Variables ###

### Start ECS Variables ###
variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  default     = "ecs-demo-cluster"
}

variable "ecs_service_name" {
  description = "ECS Service Name"
  default     = "ecs-demo-service"

}

variable "ecs_task_name" {
  description = "ECS Task Name"
  default     = "ecs-demo-task"

}

variable "container_name" {
  description = "Container Name"
  default     = "ecs-demo-container"

}

variable "container_port" {
  description = "Container Port"
  default     = 8080

}

variable "host_port" {
  description = "Host Port"
  default     = 8080

}

variable "ecr_name" {
  default = "ecs-demo"
}
### End ECS Variables ###
