variable "vpc" {
  description = "VPC CIDR block"
  type = object({
    cidr_block   = string
    dns_support  = bool
    dns_hostname = bool
  })
}

variable "name" {
  description = "Name of the IAC"
  type        = string
}

variable "environment" {
  description = "Environment of the IAC"
  type        = string
}

variable "security_groups" {
  description = "Security groups configuration"
  type = list(object({
    name        = string
    description = string
    list_of_rules = list(object({
      name                       = string
      description                = string
      protocol                   = string
      from_port                  = number
      to_port                    = number
      cidr_blocks                = list(string)
      source_security_group_name = string
      type                       = string
    }))
  }))
}

variable "subnets" {
  description = "Subnets of the IAC"
  type = list(object({
    name              = string
    availability_zone = string
    cidr_block        = string
  }))
}

variable "acm_certificate" {
  description = "ACM of the IAC"
  type = object({
    name                   = string
    dns_name               = string
    validation_method      = string
    route53_record_type    = string
    ttl                    = number
    evaluate_target_health = bool
  })
}

variable "route53_record" {
  description = "Route53 record configuration"
  type = object({
    ttl = number
    records = list(object({
      name                   = string
      route53_record_type    = string
      evaluate_target_health = bool
      route53_alias_name     = string
    }))
  })
}

variable "devops_name" {
  description = "Name of the architect"
  type = string
}

variable "project_name" {
  description = "Project name"
  type = string
}

variable "eks" {
  description = "Configuration for the EKS cluster"
  type = object({
    name        = string
    version     = string
    subnets     = list(string)
    node_group  = object({
      node_group_name             = string
      instance_types              = list(string)
      remote_access_key           = string
      source_security_group       = list(string)
      scaling_config_desired_size = number
      scaling_config_max_size     = number
      scaling_config_min_size     = number
      capacity_type               = string
      ami_type                    = string
      update_config_max_unavailable = number
    })
  })
}

variable "iam" {
  description = "IAM roles and policies for the EKS cluster"
  type = object({
    cluster_role_name                    = string
    worker_node_role_name                = string
    load_balancer_controller_name        = string
    lb_policy_name                       = string
    external_dns_role_name               = string
    external_dns_policy_name              = string
  })
}
