# Define provider and their configrations.
# Here, I am using shared AWS credentials.
provider "aws" {
  region = "ap-south-1"
}

# Defining random number to generate unique bucket name
resource "random_uuid" "test" {
}

# S3 bucekt resource
resource "aws_s3_bucket" "bucket1" {
  bucket = "s3-automation-${random_uuid.test.result}"
  acl    = "private"

  logging {
    target_bucket = "bucket-logs"
  }

  versioning {
    enabled    = true
    mfa_delete = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "Bucket"
    Environment = "Testing"
  }

}
