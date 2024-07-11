resource "aws_lb" "alb" {
  name               = "fastapi-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet-1a.id, aws_subnet.subnet-1b.id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "lb_tg" {
  name     = "fastapi-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.reorg.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
  }

  target_type = "ip"
}

# Create a Listener for the ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}