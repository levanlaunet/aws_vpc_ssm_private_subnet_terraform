
# App SG (Django / FastAPI / Next.js)
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "[${var.app_name}] Allow traffic from ALB and Bastion"
  vpc_id      = var.vpc_id  

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    description = "Allow HTTPS from EC2"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
