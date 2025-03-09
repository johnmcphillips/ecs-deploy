provider "aws" {
  region = var.region
}

resource "aws_cloudwatch_log_group" "ECS_Log_Group" {
  name              = "/ecs/${var.ecs_task_name}"
  retention_in_days = 1
}
resource "aws_security_group" "ECS_SG" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.ALB_SG.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ECS Security Group"
  }
}

resource "aws_security_group" "ALB_SG" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ALB Security Group"
  }
}

resource "aws_lb" "ALB" {
  name               = "ECS-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_SG.id]
  subnets            = [aws_subnet.PublicSubnet01.id, aws_subnet.PublicSubnet02.id]

  enable_deletion_protection = false

  tags = {
    Name = "ECS ALB"
  }
}
resource "aws_lb_target_group" "ECS_TG" {
  name        = "ECS-ALB-TG"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }
  tags = {
    Name = "ECS ALB Target Group"
  }
}

resource "aws_lb_listener" "ALB_HTTP" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = var.container_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ECS_TG.arn
  }
}