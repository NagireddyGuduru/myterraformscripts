# Create a new load balancer
resource "aws_elb" "myapp_elb" {
  name            = "myapp-elb"
  subnets         = ["${aws_subnet.web_subnets.*.id}"]
  security_groups = ["${aws_security_group.allow_http_elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 20
  }

  # instances                   = ["${aws_instance.webservers.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 60

  tags {
    Batch = "weekend"
  }
}

# Add Security Group for ELB

resource "aws_security_group" "allow_http_elb" {
  name        = "allow_http_elb"
  description = "Allow all inbound http traffic"
  vpc_id      = "${aws_vpc.myapp_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
