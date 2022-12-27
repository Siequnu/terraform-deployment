// Upload cert to ACM
resource "aws_acm_certificate" "vpn_server" {
  private_key = file("certs/private/server.key")
  certificate_body = file("certs/issued/server.crt")
  certificate_chain = file("certs/ca.crt")


  lifecycle {
    create_before_destroy = true
  }
}

// Add VPN security group
resource "aws_security_group" "vpn_security_group" {
  vpc_id = aws_vpc.dev.id
  name = "vpn_security_group"

  ingress {
    from_port = 1194
    protocol = "udp"
    to_port = 1194
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Incoming VPN connection"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

// Add client VPN endpoint
resource "aws_ec2_client_vpn_endpoint" "client-vpn-endpoint" {
  description            = "terraform-clientvpn-endpoint"
  server_certificate_arn = aws_acm_certificate.vpn_server.arn
  client_cidr_block      = "1.0.0.0/12"

  vpn_port = 1194
  transport_protocol = "udp"

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.vpn_server.arn
  }

  connection_log_options {
    enabled = false
  }

   split_tunnel = true

   vpc_id = aws_vpc.dev.id
}

# Network association
resource "aws_ec2_client_vpn_network_association" "client-vpn-network-association-private-1" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  subnet_id  = aws_subnet.dev-private-1.id
}
resource "aws_ec2_client_vpn_network_association" "client-vpn-network-association-private-2" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  subnet_id  = aws_subnet.dev-private-2.id
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn-authorisation" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
}