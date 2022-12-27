# Security Groups
resource "aws_security_group" "flat" {
  vpc_id = aws_vpc.dev.id
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
   tags = {
    Name = "flat-security-group"
  }
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = aws_vpc.dev.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    // Do not use this in production, should be limited to your own IP
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { // MSSQL
    from_port   = 1433 
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8983
    to_port     = 8983
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress { // NFS Traffic (EFS)
    from_port   = 2049 
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { // NFS Traffic (EFS)
    from_port   = 2049 
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh-allowed-security-group"
  }
}


