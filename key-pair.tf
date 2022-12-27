resource "aws_key_pair" "deploy-key" {
  key_name   = "deploy"
  public_key = file(var.PUBLIC_KEY_PATH)
  
  tags = {
    Name = "public-key"
  }
}