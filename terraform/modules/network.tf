#Create VPCs
resource "aws_vpc" "vpcs" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_support   = var.vpc.dns_support
  enable_dns_hostnames = var.vpc.dns_hostname
}

#Create internet gateways
resource "aws_internet_gateway" "igws" {
  vpc_id   = aws_vpc.vpcs.id
}

#Create subnets
resource "aws_subnet" "subnets" {
  vpc_id   = aws_vpc.vpcs.id
  for_each = {
    for subnet in var.subnets : subnet.name => subnet
  }
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/eks_cluster" = "owned"
    "kubernetes.io/role/elb"                  = "1"
  }
}

#Create route tables
resource "aws_route_table" "internet_route" {
  vpc_id   = aws_vpc.vpcs.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igws.id
  }
  lifecycle {
    ignore_changes = all
  }
}

#Overwrite default route table of VPCs with our route table entries 
resource "aws_main_route_table_association" "set_master_default_route_tables" {
  vpc_id         = aws_vpc.vpcs.id
  route_table_id = aws_route_table.internet_route.id
}

#Create SG
resource "aws_security_group" "security_groups" {
  for_each = {
    for sg in var.security_groups : sg.name => sg
  }
  name        = "${each.value.name}"
  description = each.value.description
  vpc_id      = aws_vpc.vpcs.id
}

resource "aws_security_group_rule" "ingress_egress_rule" {
  for_each = {
    for sg_rule in local.list_of_rules : sg_rule.name => sg_rule
    if length(sg_rule) > 0
  }
  security_group_id = aws_security_group.security_groups[each.value.sg_name].id
  type              = each.value.type
  description       = each.value.description
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_blocks       = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  source_security_group_id = (
    each.value.source_security_group_name != null ?
    aws_security_group.security_groups[each.value.source_security_group_name].id : null
  )
}
