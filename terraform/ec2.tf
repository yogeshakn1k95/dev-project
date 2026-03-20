# -----------------------------
# Security Group for EC2
# -----------------------------
resource "aws_security_group" "ec2_sg" {
  name   = "devops-ec2-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------
# Ansible Server
# -----------------------------
resource "aws_instance" "ansible" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "t2.micro"

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "keypair01"
  associate_public_ip_address = true

  tags = {
    Name = "ansible-server"
  }
}

# -----------------------------
# Jenkins Server
# -----------------------------
resource "aws_instance" "jenkins" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "t2.micro"

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "keypair01"
  associate_public_ip_address = true

  tags = {
    Name = "jenkins-server"
  }
}

# -----------------------------
# Outputs (IMPORTANT)
# -----------------------------
output "ansible_public_ip" {
  value = aws_instance.ansible.public_ip
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}
