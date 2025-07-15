provider "aws" {
  region = var.region
  version = "~> 5.0"
}

# Security Group para permitir SSH y HTTP
resource "aws_security_group" "web_sg" {
  name_prefix = "demo-web-"
  description = "Security group for demo web server"

  # Permitir SSH (puerto 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir HTTP (puerto 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir todo el tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-web-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hola mundo desde Terraform!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "DemoWeb"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ip.txt"
  }
}

# REMOVER estas líneas duplicadas:
# output "instance_public_ip" { ... }
# output "website_url" { ... }