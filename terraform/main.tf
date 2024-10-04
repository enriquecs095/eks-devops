module "devsu_test" {
  source      = "./modules"

  environment = var.environment

  providers = {
    aws = aws.default_region
  }

  name        = "devsu"
  vpc = {
    cidr_block   = "10.0.0.0/16"
    dns_support  = true
    dns_hostname = true
  }

  subnets = [
    {
      name              = "subnet_1"
      availability_zone = "us-east-1a"
      cidr_block        = "10.0.1.0/24"
    },
    {
      name              = "subnet_2"
      availability_zone = "us-east-1b"
      cidr_block        = "10.0.2.0/24"
    }
  ]

  security_groups = [
    {
      name        = "sg_eks_worker_nodes"
      description = "Security group for the EKS  cluster"
      list_of_rules = [
        {
          name                       = "ingress_rule_1"
          description                = "Allow to connect ssh from port 22 "
          protocol                   = "tcp"
          from_port                  = 22
          to_port                    = 22
          cidr_blocks                = ["0.0.0.0/0"]
          source_security_group_name = null
          type                       = "ingress"
        },
        {
          name                       = "egress_rule_1"
          description                = "Allow outbound traffic to any port"
          protocol                   = "-1"
          from_port                  = 0
          to_port                    = 0
          cidr_blocks                = ["0.0.0.0/0"]
          source_security_group_name = null
          type                       = "egress"
        },
      ]
    },

  ]

  eks = {
    name = "eks_cluster"
    version= "1.29"
    subnets = [
      "subnet_1",
      "subnet_2"
    ]
    node_group = {
      node_group_name = "eks_cluster_group"
      instance_types= [
        "t2.medium"
        ]
      remote_access_key="eks_cluster_vms"
      source_security_group= ["sg_eks_worker_nodes"]
      scaling_config_desired_size = 2
      scaling_config_max_size = 2
      scaling_config_min_size =1
      capacity_type = "ON_DEMAND"
      ami_type = "AL2_x86_64"
      update_config_max_unavailable=1
    }
  }

  iam = {
    cluster_role_name = "eks_role"
    worker_node_role_name = "eks_worker_node_group_role"
    load_balancer_controller_name = "aws-load-balancer-controller"
    lb_policy_name= "ingress_controller_policy"
    external_dns_role_name = "external_dns_role"
    external_dns_policy_name = "external_dns_policy"
  }

  acm_certificate = {
    name                   = "acm_1"
    dns_name               = "devopsworld.pro."
    validation_method      = "DNS"
    route53_record_type    = "A"
    ttl                    = 60
    evaluate_target_health = true
  }


  route53_record = {
    ttl = 60
    records = [
      {
        name                   = "record_1"
        route53_record_type    = "A"
        evaluate_target_health = true
        route53_alias_name     = "devsu"
      },
    ]
  }

  devops_name  = "Enrique"
  project_name = "devsu"

}
