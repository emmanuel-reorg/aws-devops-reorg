resource "aws_ecs_cluster" "ecs-reorg" {
  name = "ecs-reorg"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "fastapi-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name  = "fastapi-container"
      image = "891377034703.dkr.ecr.us-east-1.amazonaws.com/fastapi-repo:latest"
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/fastapi-task"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    },
  ])
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

resource "aws_ecs_service" "service" {
  name            = "fastapi-service"
  cluster         = aws_ecs_cluster.ecs-reorg.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.subnet-1a.id, aws_subnet.subnet-1b.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_tg.arn
    container_name   = "fastapi-container"
    container_port   = 8000
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}