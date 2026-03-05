resource "aws_security_group" "ag_security_grp" {
  name="autoscale-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_launch_template" "ag_template" {
  name_prefix = "autoscale_template"
  image_id = "ami-id"
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.ag_security_grp.id]
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y nginx curl

systemctl enable nginx
systemctl start nginx

INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<HTML > /var/www/html/index.html
<h1>Auto Scaling Project</h1>
<h2>Instance Private IP: $INSTANCE_IP</h2>
HTML

EOF
)

}


resource "aws_lb_target_group" "ag_tg" {
  name = "ag-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb" "ag_alb" {
  name="ag-load-balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.ag_security_grp.id]
  subnets = var.subnet_ids
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.ag_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ag_tg.arn
  }
}

resource "aws_autoscaling_group" "my_ag" {
  desired_capacity = 2
  max_size = 3
  min_size = 1
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = [aws_lb_target_group.ag_tg.arn]
  launch_template {
    id = aws_launch_template.ag_template.id
    version = "$Latest"

  }
  tag {
    key = "Name"
    value = "autoscale_instance"
    propagate_at_launch = true
  }
}



















