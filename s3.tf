resource "aws_s3_bucket" "s3-bucket-1"{
  bucket = "s3-bucket-1"

  tags = {
    Name = "s3-bucket-1"
  }
}

resource "aws_s3_bucket" "s3-cloudtrail-bucket"{
  bucket = "s3-cloudtrail-bucket"

  tags = {
    Name = "s3-cloudtrail-bucket"
  }
}