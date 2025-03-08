resource "aws_ecr_repository" "ECR" {
  name = "ecs-demo"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "ECS ECR Repository"
  }
}

resource "aws_ecs_cluster" "ECS" {
  name = var.ecs_cluster_name
  tags = {
    Name = "ECS Demo Cluster"
  }
}

resource "aws_ecs_task_definition" "ECS_Task_Definition" {
  family = var.ecs_task_name
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "256"
  memory = "512"
  execution_role_arn = aws_iam_role.ECS_Task_Role.arn
  container_definitions = jsonencode([{
    name = var.container_name
    image = "${aws_ecr_repository.ECR.repository_url}:latest"
    portMappings = [{
      containerPort = var.container_port
      hostPort = var.container_port
      protocol = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.ecs_task_name}"
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}