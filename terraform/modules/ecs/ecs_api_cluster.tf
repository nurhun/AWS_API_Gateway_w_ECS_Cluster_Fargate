# --- ecs/main.tf ---

resource "aws_ecs_cluster" "ecs_api_cluster" {
  name = var.ecs_cluster_name
  # capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.movies_dns.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_api_cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

resource "aws_ecs_task_definition" "ecs_api_task_definition" {
  family                   = var.task_definition_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = <<TASK_DEFINITION
[
  {
      "name": "api",
      "image": "521156286538.dkr.ecr.eu-north-1.amazonaws.com/django_rest_framework_movies_apis_w_react_frontend_backend:run-v8",
      "cpu": 1024,
      "memory": 2048,
      "portMappings": [
          {
              "name": "api-8000-tcp",
              "containerPort": 8000,
              "hostPort": 8000,
              "protocol": "tcp",
              "appProtocol": "http"
          }
      ],
      "essential": true,
      "environment": [
          {
              "name": "SECRET_KEY",
              "value": "classified"
          }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-create-group": "true",
              "awslogs-group": "/ecs/t4",
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


resource "aws_ecs_service" "ecs_api_service" {
  name                = var.ecs_service_name
  cluster             = aws_ecs_cluster.ecs_api_cluster.id
  task_definition     = aws_ecs_task_definition.ecs_api_task_definition.arn
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  desired_count       = 1

  network_configuration {
    assign_public_ip = true
    subnets          = [var.subnet_id]
    security_groups  = [var.sg_id]
  }

  service_registries {
    port         = "8000"
    registry_arn = aws_service_discovery_service.movies_svc_discovery.arn
  }

}

resource "aws_service_discovery_private_dns_namespace" "movies_dns" {
  name        = "movies.terraform.local"
  description = "movies"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "movies_svc_discovery" {
  name = "moviessvcdiscovery"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.movies_dns.id

    dns_records {
      ttl  = 60
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }

}