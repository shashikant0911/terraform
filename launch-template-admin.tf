resource "aws_launch_template" "ecs_lt_admin" {
  name_prefix   = var.lt_admin
  image_id      = "ami-028c6514ea77d5ac3"
  instance_type = "t4g.micro"



  key_name               = "dockey"
  vpc_security_group_ids = [aws_security_group.irs-admin.id]
  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Platform    = "IRS"
      Environment = "Test2"
      Role        = "ASG-ADMIN"
      RoleType    = "ECSContainerHost"
      Name        = "IRS-Test-ADMIN-Host"
    }
  }

  user_data = filebase64("${path.module}/ecs.sh")
}
