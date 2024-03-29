@@ -0,0 +1,25 @@
# creating instance 1

resource "aws_instance" "instance" {
  ami               = var.ami
  instance_type     = var.type
  key_name          = var.key_pair
  security_groups   = [aws_security_group.security_group.id]
  subnet_id         = aws_subnet.public_subnet_az1.id
  availability_zone = data.aws_availability_zones.available_zones.names[0]

    user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              docker pull ansible/ansible:latest
              docker run -dit --name ansible_container -v ~/terraform-modules-2:/ansible/playbooks ansible/ansible:latest /bin/bash
              EOF

  tags = {
    Name   = "${var.project_name}-instance"
    source = "terraform"
  }
}