resource "aws_autoscaling_group" "ecs_asg" {
  name                = var.app_asg
  vpc_zone_identifier = aws_subnet.private_subnet[*].id
  desired_capacity    = 1
  max_size            = 5
  min_size            = 1

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

resource "aws_autoscaling_group" "ecs_asg_admin" {
  name                = var.admin_asg
  vpc_zone_identifier = aws_subnet.private_subnet[*].id
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.ecs_lt_admin.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

resource "aws_lb" "ecs_alb" {
  name               = "irs-test2-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.irs-admin.id, aws_security_group.irs-api.id]
  subnets            = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id, aws_subnet.public_subnet[2].id]

  tags = {
    Name = "ecs-alb"
  }
}

resource "aws_lb_listener" "ecs_alb_listener_http" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "ecs_alb_listener_http-api" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 81
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_lb_listener" "ecs_alb_listener_admin_https" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 8443
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg_admin.arn
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = var.ecs_api_tg
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "ecs_tg_admin" {
  name        = var.ecs_admin_tg
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "scheduler_tg_admin" {
  name        = "irs-scheduler-test2-admin-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "scheduler_api_tg" {
  name        = "irs-scheduler-test2-api-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "ecs_alb_listener_rule_8443" {
  listener_arn = aws_lb_listener.ecs_alb_listener_admin_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.scheduler_tg_admin.arn
  }

  condition {
    host_header {
      values = ["test2-interpreterreservationschedulerapi.amnhealthcare.com"]
    }
  }
}

resource "aws_lb_listener_rule" "ecs_alb_listener_rule_443" {
  listener_arn = aws_lb_listener.ecs_alb_listener_http-api.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.scheduler_api_tg.arn
  }

  condition {
    host_header {
      values = ["test-interpreterreservationschedulerapi.amnhealthcare.com"]
    }
  }
}
