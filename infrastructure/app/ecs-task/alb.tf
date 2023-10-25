locals {
  internal_cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

resource "aws_security_group" "alb" {
  count       = var.create_ingress_alb ? 1 : 0
  name        = "${var.ecs_service_name}-alb-sg"
  description = "Security group for ${var.ecs_service_name} ECS service ALB"
  vpc_id      = local.vpc_id
  tags        = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "alb_internal_access" {
  count             = var.create_ingress_alb && var.internal_alb ? length(local.internal_cidr_blocks) : 0
  security_group_id = aws_security_group.alb[0].id
  from_port         = var.ecs_task_container_port
  to_port           = var.ecs_task_container_port
  ip_protocol       = "tcp"
  cidr_ipv4         = local.internal_cidr_blocks[count.index]
  tags              = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "alb_public_access" {
  count             = var.create_ingress_alb && !var.internal_alb ? 1 : 0
  security_group_id = aws_security_group.alb[0].id
  from_port         = var.ecs_task_container_port
  to_port           = var.ecs_task_container_port
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  tags              = var.tags
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  count             = var.create_ingress_alb ? 1 : 0
  security_group_id = aws_security_group.alb[0].id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  tags              = var.tags
}

resource "aws_lb" "this" {
  count                      = var.create_ingress_alb ? 1 : 0
  name                       = var.ecs_service_name
  internal                   = var.internal_alb
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb[0].id]
  subnets                    = var.internal_alb ? var.private_subnet_ids : var.public_subnet_ids
  enable_deletion_protection = false
  tags                       = var.tags
}

resource "aws_lb_target_group" "this" {
  count       = var.create_ingress_alb ? 1 : 0
  name        = var.ecs_service_name
  port        = var.ecs_task_container_port
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip"
  tags        = var.tags
}

resource "aws_lb_listener" "this" {
  count             = var.create_ingress_alb ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = var.ecs_task_container_port
  protocol          = "HTTP"
  tags              = var.tags
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }
}
