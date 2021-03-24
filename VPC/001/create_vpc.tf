# Define provider and their configrations.
# Here, I am using shared AWS credentials.
provider "aws" {
  region = "ap-south-1"
}

# Defining AWS VPC
resource "aws_vpc" "terraform_test_vpc_1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Testing VPC"
  }

}

# Defining AWS Subnet
resource "aws_subnet" "terraform_test_subnet_1" {
  vpc_id = aws_vpc.terraform_test_vpc_1.id

  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Testing Sbnet"
  }

}
