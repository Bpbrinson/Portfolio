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
      image     = "724843234768.dkr.ecr.us-east-1.amazonaws.com/brandon-portfolio-repo:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
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

