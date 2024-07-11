resource "aws_security_group" "reorg_default_sg" {
  vpc_id = aws_vpc.reorg.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "reorg_default_sg"
  }
}

resource "aws_security_group" "s3_vpc_endpoint_sg" {
  name        = "s3-vpc-endpoint-sg"
  description = "Security group for S3 VPC endpoint"
  vpc_id      = aws_vpc.reorg.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Security Group for the Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Security group for Load Balancer"
  vpc_id      = aws_vpc.reorg.id

  # Allow inbound HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb-sg"
  }
}

# Security Group for the ECS Service
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Security group for ECS Service"
  vpc_id      = aws_vpc.reorg.id

  # Allow inbound traffic from the Load Balancer security group on the application port
  # Assuming the application runs on port 8000
  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg"
  }
}


