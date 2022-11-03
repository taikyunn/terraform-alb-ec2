# ALB
resource "aws_lb" "alb" {
  load_balancer_type = "application"
  name = "alb-test"
  security_groups = [ aws_security_group.alb-sg.id ]
  subnets = [ aws_subnet.alb-ec2-subnet-public-1a.id, aws_subnet.alb-ec2-subnet-public-1c.id ]
}
