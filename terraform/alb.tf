resource "aws_lb" "front_end" {
  name               = "portfolio-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  ip_address_type = "dualstack"
  tags = {
    Project = "portfolio"
  }
}

resource "aws_lb_target_group" "front_end" {
  name     = "portfolio-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.portfolio_vpc.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
  tags = {
    Project = "portfolio"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
  tags = {
    Project = "portfolio"
  }
}

output "alb_dns_name" {
  value       = aws_lb.front_end.dns_name
  description = "DNS name of the Application Load Balancer"
}