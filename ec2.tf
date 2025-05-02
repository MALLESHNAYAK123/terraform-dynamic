resource "aws_instance" "app-instance" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t3.large"
  key_name               = "mallesh"
  subnet_id              = aws_subnet.pub-subnets[0].id
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  tags = {
    Nmae = "app-instance-${var.project_name}"
  }
}