provider "aws" {
  region  = var.region
  profile = "default"
}

resource "aws_instance" "example" {
  ami           = var.ami_small
  instance_type = var.instance_small
}

resource "aws_s3_bucket" "bucket" {
  bucket = "randombucket13654653465"
  acl    = "private"
  tags = {
    name = "My bucket"
  }
}

resource "aws_dynamodb_table" "dynamotable" {
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "userid"
  name           = "users2"
  attribute {
    name = "userid"
    type = "S"
  }
}

resource "aws_iam_user" "userx" {
  name = "userx"
  path = "/system/"
  tags = {
    source = "terraform"
  }
}

resource "aws_iam_access_key" "userx" {
  user = aws_iam_user.userx.name
}

resource "aws_iam_user_policy" "userx_policy" {
  name = "userx_policy"
  user = aws_iam_user.userx.name
  policy = data.aws_iam_policy_document.policy_test.json

}

data "aws_iam_policy_document" "policy_test" {
  statement {
    actions = [
      "ec2:*",
      "s3:*",
      "dynamodb:*"
    ]
    resources = [
      aws_instance.example.arn,
      aws_s3_bucket.bucket.arn,
      aws_dynamodb_table.dynamotable.arn
    ]
  }
}