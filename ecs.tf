resource "aws_ecr_repository" "ECR" {
  name = var.ecr_name
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

resource "aws_ecs_service" "ECS_Service" {
    name = var.ecs_service_name
    cluster = aws_ecs_cluster.ECS.id
    task_definition = aws_ecs_task_definition.ECS_Task_Definition.arn
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
        subnets = [aws_subnet.PrivateSubnet01.id]
        security_groups = [aws_security_group.ECS_SG.id]
        assign_public_ip = false
    }
    load_balancer {
        target_group_arn = aws_lb_target_group.ECS_TG.arn
        container_name = var.container_name
        container_port = var.container_port
    }
    depends_on = [aws_lb_listener.ALB_HTTP]
    tags = {
        Name = "ECS Demo Service"
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
      hostPort = var.host_port
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