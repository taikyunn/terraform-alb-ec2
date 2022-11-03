# ALB
resource "aws_lb" "alb-ec2" {
  load_balancer_type = "application"
  internal           = false
  name               = "alb-test"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.alb-ec2-subnet-public-1a.id, aws_subnet.alb-ec2-subnet-public-1c.id]
  ip_address_type    = "ipv4"
  tags = {
    "Name" = "alb-ec2"
  }
}

# target group
resource "aws_lb_target_group" "alb-ec2-tg" {
  name             = "alb-ec2-tg"
  target_type      = "instance"
  protocol_version = "HTTP1"
  port             = 80
  protocol         = "HTTP"
  vpc_id           = aws_vpc.alb-ec2-vpc.id
  tags = {
    "Name" = "alb-ec2-tg"
  }
  health_check {
    path                = "/"
    interval            = 30
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200,301"
  }
}

# target groupにEC2インスタンスを登録
resource "aws_lb_target_group_attachment" "attach-alb-ec2-instance" {
  target_group_arn = aws_lb_target_group.alb-ec2-tg.arn
  target_id        = aws_instance.alb-ec2-instance.id
}

# リスナー設定
resource "aws_lb_listener" "alb-ec2-listener" {
  load_balancer_arn = aws_lb.alb-ec2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-ec2-tg.arn
  }
}
