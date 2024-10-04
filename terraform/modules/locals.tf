locals {

  //network security groups rules
  list_of_rules = toset(flatten([
    for sg in var.security_groups : [
      for rule in sg.list_of_rules : [{
        sg_name : sg.name
        name : rule.name
        description : rule.description
        protocol : rule.protocol
        from_port : rule.from_port
        to_port : rule.to_port
        cidr_blocks : rule.cidr_blocks
        source_security_group_name : rule.source_security_group_name
        type : rule.type
      }]
    ]
  ]))

  subnets_eks= flatten([
      for subnet in var.eks.subnets :
      aws_subnet.subnets["${subnet}"].id
  ])

  security_groups_eks = flatten([
      for sg in var.eks.node_group.source_security_group :
      aws_security_group.security_groups["${sg}"].id
    ])

// acm && route 53
  alias = "${var.name}-${var.environment}"

  acm_certificate = {
    name              = "${var.acm_certificate.name}_${var.environment}_${var.name}"
    domain_name       = join(".", [local.alias, data.aws_route53_zone.dns.name])
    validation_method = var.acm_certificate.validation_method
  }
  
  route53_record = {
    ttl     = var.acm_certificate.ttl
    zone_id = data.aws_route53_zone.dns.zone_id
  }

}

