resource "aws_cloudwatch_log_group" "log_group" {
  name = var.ecs_log_group_name

}

resource "aws_cloudwatch_log_group" "log_group_admin" {
  name = var.log_group_admin

}

resource "aws_cloudwatch_log_group" "celery_log_group" {
  name = var.celery_log_group

}
