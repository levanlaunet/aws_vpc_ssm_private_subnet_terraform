resource "aws_instance" "ssm_ec2_instance" {
  ami                    = var.image_id
  instance_type          = var.ssm_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.ec2_security_group_id]
  key_name               = var.key_name
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.ssm_ec2_profile.name

  # user_data = <<-EOF
  #             #!/bin/bash
  #             yum install -y amazon-ssm-agent
  #             systemctl enable amazon-ssm-agent
  #             systemctl start amazon-ssm-agent
  #             EOF

  # user_data = <<-EOF
  #             #!/bin/bash
  #             curl -O https://s3.amazonaws.com/amazon-ssm-${var.region}/latest/debian_amd64/amazon-ssm-agent.deb
  #             dpkg -i amazon-ssm-agent.deb
  #             systemctl enable amazon-ssm-agent
  #             systemctl start amazon-ssm-agent
  #             EOF

  tags = {
    Name = var.ssm_instance_name
  }
}

resource "aws_iam_role" "ssm_ec2_role" {
  name = "ssm_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_ec2_profile" {
  name = "ssm_ec2_profile"
  role = aws_iam_role.ssm_ec2_role.name
}