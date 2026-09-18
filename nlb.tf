resource "aws_lb" "nlb" {
  name               = "terraform-assignment-nlb"
  internal           = false
  load_balancer_type = "network"

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "terraform-assignment-nlb"
  }
}

resource "aws_lb_target_group" "web" {
  name        = "terraform-assignment-web-tg"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    protocol = "TCP"
    port     = "80"
  }

  tags = {
    Name = "terraform-assignment-web-tg"
  }
}

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}