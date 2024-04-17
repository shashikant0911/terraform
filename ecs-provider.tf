resource "aws_ecs_capacity_provider" "ecs_capacity_provider_api" {
  name = var.api_capacity_provider

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 2
    }
  }
  tags = {
    Platform    = "IRS"
    Environment = "Test2"
    Role        = "Api Capacity Provider"
    RoleType    = "Capacity Provider"
    Name        = "IRS_test2_capacity_provider_api"
  }
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider_admin" {
  name = var.admin_capacity_provider

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg_admin.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 1
    }
  }
  tags = {
    Platform    = "IRS"
    Environment = "Test2"
    Role        = "Admin Capacity Provider"
    RoleType    = "Capacity Provider"
    Name        = "IRS_test2_capacity_provider_admin"
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.my_cluster.name

  capacity_providers = [
    aws_ecs_capacity_provider.ecs_capacity_provider_api.name,
    aws_ecs_capacity_provider.ecs_capacity_provider_admin.name,
  ]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider_api.name
  }
  lifecycle {
    ignore_changes = [
      default_capacity_provider_strategy
    ]
  }
}