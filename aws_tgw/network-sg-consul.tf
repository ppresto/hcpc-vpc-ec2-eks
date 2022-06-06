resource "aws_security_group" "consul_server" {
  name_prefix = "${var.region}-consul-server-sg"
  description = "Firewall for the consul server."
  vpc_id      = data.terraform_remote_state.hcp_consul.outputs.vpc_id
  tags = merge(
    { "Name" = "${var.region}-consul-server-sg" },
    { "Project" = var.region },
    { "Owner" = "presto" }
  )
}

#
###  Ingress Rules 
#
resource "aws_security_group_rule" "consul_server_allow_server_8301" {
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [data.terraform_remote_state.hcp_consul.outputs.hvn_cidr_block]
  description       = "Used to handle gossip from server"
}
resource "aws_security_group_rule" "consul_server_allow_server_8301_udp" {
  security_group_id = aws_security_group.consul_server.id
  type              = "ingress"
  protocol          = "udp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [data.terraform_remote_state.hcp_consul.outputs.hvn_cidr_block]
  description       = "Used to handle gossip from server"
}


resource "aws_security_group_rule" "consul_server_allow_client_8301" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8301
  to_port                  = 8301
  source_security_group_id = aws_security_group.consul_server.id
  description              = "Used to handle gossip between client agents"
}
resource "aws_security_group_rule" "consul_server_allow_client_8301_udp" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "ingress"
  protocol                 = "udp"
  from_port                = 8301
  to_port                  = 8301
  source_security_group_id = aws_security_group.consul_server.id
  description              = "Used to handle gossip between client agents"
}

#
### Egress Rules
#
resource "aws_security_group_rule" "hcp_tcp_RPC_from_clients" {
  security_group_id = aws_security_group.consul_server.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8300
  to_port           = 8300
  cidr_blocks       = [data.terraform_remote_state.hcp_consul.outputs.hvn_cidr_block]
  description       = "For RPC communication between clients and servers"
}
resource "aws_security_group_rule" "hcp_tcp_server_gossip" {
  security_group_id = aws_security_group.consul_server.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [data.terraform_remote_state.hcp_consul.outputs.hvn_cidr_block]
  description       = "Server to server gossip communication"
}
resource "aws_security_group_rule" "hcp_udp_server_gossip" {
  security_group_id = aws_security_group.consul_server.id
  type              = "egress"
  protocol          = "udp"
  from_port         = 8301
  to_port           = 8301
  cidr_blocks       = [data.terraform_remote_state.hcp_consul.outputs.hvn_cidr_block]
  description       = "Server to server gossip communication"
}
resource "aws_security_group_rule" "consul_server_allow_client_egress_8301" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 8301
  to_port                  = 8301
  source_security_group_id = aws_security_group.consul_server.id
  description              = "Used to handle gossip between client agents"
}
resource "aws_security_group_rule" "consul_server_allow_client_egress_8301_udp" {
  security_group_id        = aws_security_group.consul_server.id
  type                     = "egress"
  protocol                 = "udp"
  from_port                = 8301
  to_port                  = 8301
  source_security_group_id = aws_security_group.consul_server.id
  description              = "Used to handle gossip between client agents"
}
resource "aws_security_group_rule" "hcp_tcp_https" {
  security_group_id = aws_security_group.consul_server.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [data.terraform_remote_state.hcp_consul.outputs.hvn_cidr_block]
  description       = "The HTTPS API"
}
#resource "aws_security_group_rule" "consul_server_allow_outbound" {
#  security_group_id = aws_security_group.consul_server.id
#  type              = "egress"
#  protocol          = "-1"
#  from_port         = 0
#  to_port           = 0
#  cidr_blocks       = ["0.0.0.0/0"]
#  description       = "Allow any outbound traffic."
#}