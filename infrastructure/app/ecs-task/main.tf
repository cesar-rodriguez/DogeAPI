locals {
  ecs_cluster_arn = "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${var.ecs_cluster_name}"
  vpc_id          = data.aws_subnet.selected.vpc_id
  environment_map = [
    for k, v in var.ecs_task_environment_variables :
    {
      name  = k
      value = v
    }
  ]
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.ecs_service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_container_cpu
  memory                   = var.ecs_task_container_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name        = var.ecs_task_container_name
    image       = var.ecs_task_image_url
    environment = local.environment_map
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.this.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
    portMappings = [{
      containerPort = var.ecs_task_container_port
      hostPort      = var.ecs_task_container_port
    }]
  }])

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.ecs_service_name}"
  tags = var.tags
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.ecs_service_name}-execution-role"
  tags = var.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_execution_role.name
}


resource "aws_ecs_service" "this" {
  name            = var.ecs_service_name
  cluster         = local.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = var.ecs_service_desired_count
  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.ecs_service.id]
  }

  dynamic "load_balancer" {
    for_each = var.create_ingress_alb ? [1] : []

    content {
      target_group_arn = aws_lb_target_group.this[0].arn
      container_name   = var.ecs_service_name
      container_port   = var.ecs_task_container_port
    }
  }
  tags = var.tags
}

resource "aws_security_group" "ecs_service" {
  name        = "${var.ecs_service_name}-sg"
  description = "Security group for ${var.ecs_service_name} ECS service"
  vpc_id      = local.vpc_id
  tags        = var.tags
}

resource "aws_vpc_security_group_egress_rule" "ecs_service_egress" {
  security_group_id = aws_security_group.ecs_service.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  tags              = var.tags
}

resource "aws_vpc_security_group_egress_rule" "ecs_service_alb_ingress" {
  count                        = var.create_ingress_alb ? 1 : 0
  security_group_id            = aws_security_group.ecs_service.id
  from_port                    = var.ecs_task_container_port
  to_port                      = var.ecs_task_container_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb[0].id
  tags                         = var.tags
}
