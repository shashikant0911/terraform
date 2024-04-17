resource "aws_ecs_cluster" "my_cluster" {
  name = var.cluster_name

  tags = {
    Platform    = "IRS"
    Environment = "Test2"
    Role        = "ECS Cluster"
    RoleType    = "Ecs Cluster"
    Name        = "IRS-Test2"
  }
}
