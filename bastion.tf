resource "aws_instance" "bastion_host" {
  ami             = "ami-080e1f13689e07408"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.irs-bastion.id]

  tags = {
    Name = "BastionHost"
  }
}