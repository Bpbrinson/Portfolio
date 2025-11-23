resource "aws_ecs_cluster" "brandon-portfolio-cluster" {
  name = "brandon-portfolio-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "portfolio_task" {
  family                   = "portfolio-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::724843234768:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "portfolio-container"
      image     = "724843234768.dkr.ecr.us-east-1.amazonaws.com/brandon/portfolio:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# --- ECS Service (start with 1 task) ---
resource "aws_ecs_service" "portfolio_service" {
  name            = "portfolio-service"
  cluster         = aws_ecs_cluster.brandon-portfolio-cluster.id
  task_definition = aws_ecs_task_definition.portfolio_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "portfolio-container"
    container_port   = 8000
  }

  network_configuration {
    subnets          = [aws_subnet.public_subnet.id]
    security_groups  = [aws_security_group.task_sg.id]
    assign_public_ip = true
  }

  # (optional but recommended) ensure Terraform waits for a stable service
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
}
# Target to scale the ECS service's DesiredCount
resource "aws_appautoscaling_target" "ecs_desired_count" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.brandon-portfolio-cluster.name}/${aws_ecs_service.portfolio_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 2
}

# Target tracking policy based on average CPU utilization
resource "aws_appautoscaling_policy" "cpu_target_tracking" {
  name               = "portfolio-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.ecs_desired_count.service_namespace
  resource_id        = aws_appautoscaling_target.ecs_desired_count.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_desired_count.scalable_dimension

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 50 # aim for ~50% avg CPU
    scale_in_cooldown  = 60 # seconds
    scale_out_cooldown = 60 # seconds
  }
}

# Load balancer to distribute traffic to ECS tasks
resource "aws_lb" "portfolio_lb" {
  name               = "portfolio-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_portfolio_sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "portfolio-lb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"  # REQUIRED for awsvpc/Fargate :contentReference[oaicite:4]{index=4}

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.portfolio_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
