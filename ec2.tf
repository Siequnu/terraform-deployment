resource "aws_instance" "aws-ec2" {
  ami           = var.AWS_AMI
  instance_type = var.AWS_INSTANCE_TYPE

  subnet_id              = aws_subnet.dev-private-1.id
  vpc_security_group_ids = [aws_security_group.ssh-allowed.id]
  key_name               = aws_key_pair.deploy-key.id

  tags = {
    Name : "aws-ec2"
  }
}




