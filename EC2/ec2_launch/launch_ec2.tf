# Define provider and their configrations.
# Here, I am using shared AWS credentials.
provider "aws" {
  region = "ap-south-1"
}

# AWS EC2 instance resource
resource "aws_instance" "first-ec2-instance" {
  ami           = "ami-0d758c1134823111a"
  instance_type = "t2.micro"

  root_block_device {
    encrypted = true
  }

  tags = {
    Name        = "Testing Terraform"
    Environemnt = "Testing"
  }
}
