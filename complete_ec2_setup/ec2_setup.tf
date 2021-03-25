# Defining AWS VPC
resource "aws_vpc" "ec2_setup_vpc_1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "EC2 Setup VPC"
  }

}

# Defining Internet Gateway
resource "aws_internet_gateway" "ec2_setup_igtw_1" {
  vpc_id = aws_vpc.ec2_setup_vpc_1.id

  tags = {
    Name = "EC2 Setup IGW"
  }

}

# Defining Route Table
resource "aws_route_table" "ec2_setup_route_table_1" {
  vpc_id = aws_vpc.ec2_setup_vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_setup_igtw_1.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.ec2_setup_igtw_1.id
  }

  tags = {
    Name = "EC2 Setup Route Table"
  }
}

# Defining AWS Subnet
resource "aws_subnet" "ec2_setup_subnet_1" {
  vpc_id = aws_vpc.ec2_setup_vpc_1.id

  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "EC2 Setup Subnet"
  }

}

# Define association on Route Table on Subnet
resource "aws_route_table_association" "ec2_setup_route_table_ass_1" {
  subnet_id      = aws_subnet.ec2_setup_subnet_1.id
  route_table_id = aws_route_table.ec2_setup_route_table_1.id
}

# Define security group creation
resource "aws_security_group" "ec2_setup_security_grp_1" {
  name        = "allow_web_traffic"
  description = "Allow Web traffic"
  vpc_id      = aws_vpc.ec2_setup_vpc_1.id

  ingress {
    description = "HTTPs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Setup Allow Web Traffic"
  }
}

# Define network interface
resource "aws_network_interface" "ec2_setup_network_interface_1" {
  subnet_id       = aws_subnet.ec2_setup_subnet_1.id
  private_ip      = "10.0.1.50"
  security_groups = [aws_security_group.ec2_setup_security_grp_1.id]
}

# Define Elastic IP configuration
resource "aws_eip" "ec2_setup_eip_1" {
  vpc                       = true
  network_interface         = aws_network_interface.ec2_setup_network_interface_1.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.ec2_setup_igtw_1]
}

# Define AWS EC2 Instance creation
resource "aws_instance" "ec2_setup_instance_1" {
  ami               = "ami-0d758c1134823146a"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name          = "root_ec2_1"

  root_block_device {
    encrypted = true
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.ec2_setup_network_interface_1.id
  }

  tags = {
    Name = "EC2 Setup Instance"
  }

  user_data = <<-EOF
  sudo apt update -y
  sudo apt install apache2 -y
  sudo systemctl start apache2
  sudo bash -c 'echo Your first web server > /var/www/html/index.html'
  EOF

}
