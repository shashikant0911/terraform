resource "aws_launch_template" "ecs_lt" {
  name_prefix   = var.lt_app
  image_id      = "ami-028c6514ea77d5ac3"
  instance_type = "t4g.micro"



  key_name               = "dockey"
  vpc_security_group_ids = [aws_security_group.irs-api.id]
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
      Role        = "ASG-API"
      RoleType    = "ECSContainerHost"
      Name        = "IRS-Test2-API-Host"
    }
  }
  
  user_data = filebase64("${path.module}/ecs.sh")
}
