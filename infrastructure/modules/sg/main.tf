data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["desafio-devops-vpc"]
  }
}


resource "aws_security_group" "public_security_group" {
  vpc_id      = data.aws_vpc.selected.id # Use the VPC ID retrieved from the data source
  name        = "public-security-group"
  description = "Security group allowing HTTP and HTTPS traffic from anywhere"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_security_group" "private_security_group" {
  vpc_id      = data.aws_vpc.selected.id
  name        = "private-security-group"
  description = "allowing TCP port 8000 from the public-security-group"


  ingress {
    description     = "Allow access from load balancer"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public_security_group.id]
  }

  ingress {
    description = "Allow internal VPC access"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
