terraform {
  required_version = ">= 0.11.6"
}

# https://www.consul.io/docs/agent/options.html#ports
module "consul_client_ports_aws" {
  source = "github.com/TMXGroup/terraform-aws-module-consul-client-ports"

  create            = "${var.create}"
  name              = "${var.name}"
  vpc_id            = "${var.vpc_id}"
  cidr_blocks       = "${var.cidr_blocks}"
  consul_sg_group   = "${var.vault_sg_group}"
  tags              = "${var.tags}"
}

# Server RPC (Default 8300) - TCP. This is used by servers to handle incoming requests from other agents on TCP only.
resource "aws_security_group_rule" "server_rpc_tcp" {
  count = "${var.create ? 1 : 0}"

  security_group_id         = "${module.consul_client_ports_aws.consul_client_sg_id}"
  type                      = "ingress"
  protocol                  = "tcp"
  from_port                 = 8300
  to_port                   = 8300
  source_security_group_id  = "${var.vault_sg_group}"
  description               = "Vault cluster SG"
}

resource "aws_security_group_rule" "server_rpc_tcp_internal" {
  count = "${var.create ? 1 : 0}"

  security_group_id         = "${module.consul_client_ports_aws.consul_client_sg_id}"
  type                      = "ingress"
  protocol                  = "tcp"
  from_port                 = 8300
  to_port                   = 8300
  source_security_group_id  = "${module.consul_client_ports_aws.consul_client_sg_id}"
  description               = "Internal consul cluster SG"
}

# As of Consul 0.8, it is recommended to enable connection between servers through port 8302 for both
# TCP and UDP on the LAN interface as well for the WAN Join Flooding feature. See also: Consul 0.8.0
# CHANGELOG and GH-3058
# https://github.com/hashicorp/consul/blob/master/CHANGELOG.md#080-april-5-2017
# https://github.com/hashicorp/consul/issues/3058

# Serf WAN (Default 8302) - TCP. This is used by servers to gossip over the WAN to other servers on TCP and UDP.
resource "aws_security_group_rule" "serf_wan_tcp" {
  count = "${var.create ? 1 : 0}"

  security_group_id         = "${module.consul_client_ports_aws.consul_client_sg_id}"
  type                      = "ingress"
  protocol                  = "tcp"
  from_port                 = 8302
  to_port                   = 8302
  source_security_group_id  = "${var.vault_sg_group}"
  description               = "Vault cluster SG"
}

resource "aws_security_group_rule" "serf_wan_tcp_internal" {
  count = "${var.create ? 1 : 0}"

  security_group_id         = "${module.consul_client_ports_aws.consul_client_sg_id}"
  type                      = "ingress"
  protocol                  = "tcp"
  from_port                 = 8302
  to_port                   = 8302
  source_security_group_id  = "${module.consul_client_ports_aws.consul_client_sg_id}"
  description               = "Internal consul cluster SG"
}

# Serf WAN (Default 8302) - UDP. This is used by servers to gossip over the WAN to other servers on TCP and UDP.
resource "aws_security_group_rule" "serf_wan_udp" {
  count = "${var.create ? 1 : 0}"

  security_group_id         = "${module.consul_client_ports_aws.consul_client_sg_id}"
  type                      = "ingress"
  protocol                  = "udp"
  from_port                 = 8302
  to_port                   = 8302
  source_security_group_id  = "${var.vault_sg_group}"
  description               = "Vault cluster SG"
}

resource "aws_security_group_rule" "serf_wan_udp_internal" {
  count = "${var.create ? 1 : 0}"

  security_group_id         = "${module.consul_client_ports_aws.consul_client_sg_id}"
  type                      = "ingress"
  protocol                  = "udp"
  from_port                 = 8302
  to_port                   = 8302
  source_security_group_id  = "${module.consul_client_ports_aws.consul_client_sg_id}"
  description               = "Internal consul cluster SG"
}