# --- ecs/frontend_cluster.tf ---

resource "aws_ecs_cluster" "ecs_frontend_cluster" {
  name               = "FrontCluster"

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_frontend_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_frontend_cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  # default_capacity_provider_strategy {
  #   base              = 1
  #   weight            = 100
  #   capacity_provider = "FARGATE"
  # }
}

resource "aws_ecs_task_definition" "ecs_frontend_task_definition" {
  family                   = "front"
  cpu                      = "1024"
  memory                   = "2048"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::521156286538:role/ecs_task_execution_role"
  task_role_arn            = "arn:aws:iam::521156286538:role/ecs_task_execution_role"

  container_definitions = <<TASK_DEFINITION
[
    {
        "name": "nginx",
        "image": "521156286538.dkr.ecr.eu-north-1.amazonaws.com/django_rest_framework_movies_apis_w_react_frontend_nginx:ecs-v2",
        "cpu": 1024,
        "memory": 2048,
        "portMappings": [
            {
                "name": "nginx-80-tcp",
                "containerPort": 80,
                "hostPort": 80,
                "protocol": "tcp",
                "appProtocol": "http"
            }
        ],
        "essential": true,
        "environment": [
            {
                "name": "NGINX_SERVER_NAME",
                "value": "_"
            },
            {
                "name": "NGINX_PROXY_PASS",
                "value": "https://mx7p3a54n4.execute-api.eu-north-1.amazonaws.com"
            },
            {
                "name": "NGINX_PORT",
                "value": "80"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-create-group": "true",
                "awslogs-group": "/ecs/front",
                "awslogs-region": "eu-north-1",
                "awslogs-stream-prefix": "ecs"
            }
        }
    }
]
TASK_DEFINITION

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "ecs_frontend_service" {
  name            = "frontsvc5"
  cluster         = aws_ecs_cluster.ecs_frontend_cluster.id
  task_definition = aws_ecs_task_definition.ecs_frontend_task_definition.arn

  launch_type         = "FARGATE"
  platform_version    = "LATEST"
  scheduling_strategy = "REPLICA"
  desired_count       = "1"

  network_configuration {
    assign_public_ip = "true"
    subnets          = [var.subnet_id]
    security_groups  = [var.sg_id]
  }

  load_balancer {
    container_name   = "nginx"
    container_port   = "80"
    target_group_arn = var.lb_target_group_arn
  }

  health_check_grace_period_seconds = "10"
}