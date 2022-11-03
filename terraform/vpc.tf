# vpc
resource "aws_vpc" "alb-ec2-vpc" {
  cidr_block = "192.168.20.0/24"
  tags = {
    "Name" = "alb-ec2-vpc"
  }
}

# subnet1
resource "aws_subnet" "alb-ec2-subnet-public-1a" {
  vpc_id            = aws_vpc.alb-ec2-vpc.id
  cidr_block        = "192.168.20.0/25"
  availability_zone = "ap-northeast-1a"
  tags = {
    "Name" = "alb-ec2-vpc-public-1a"
  }
}

# subnet2
resource "aws_subnet" "alb-ec2-subnet-public-1c" {
  vpc_id            = aws_vpc.alb-ec2-vpc.id
  cidr_block        = "192.168.20.128/25"
  availability_zone = "ap-northeast-1c"
  tags = {
    "Name" = "alb-ec2-vpc-public-1c"
  }
}

# igw
resource "aws_internet_gateway" "alb-ec2-igw" {
  vpc_id = aws_vpc.alb-ec2-vpc.id
  tags = {
    "Name" = "value"
  }
}

# route table
resource "aws_route_table" "alb-ec2-rt" {
  vpc_id = aws_vpc.alb-ec2-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.alb-ec2-igw.id
  }
  tags = {
    "Name" = "alb-ec2-rt"
  }
}

# subnetとroute tableの関連付け
resource "aws_route_table_association" "alb-ec2-rt-association-1" {
  subnet_id      = aws_subnet.alb-ec2-subnet-public-1a.id
  route_table_id = aws_route_table.alb-ec2-rt.id
}

resource "aws_route_table_association" "alb-ec2-rt-association-2" {
  subnet_id      = aws_subnet.alb-ec2-subnet-public-1c.id
  route_table_id = aws_route_table.alb-ec2-rt.id
}

# security group(EC2用)
resource "aws_security_group" "ec2-sg" {
  name   = "ec2-sg"
  vpc_id = aws_vpc.alb-ec2-vpc.id
  tags = {
    "Name" = "ec2-sg"
  }

  # インバウンドルール
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# security group(ALB用)
resource "aws_security_group" "alb-sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.alb-ec2-vpc.id
  tags = {
    "Name" = "alb-sg"
  }

  # インバウンドルール
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
