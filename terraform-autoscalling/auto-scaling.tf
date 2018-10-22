# Launch Configuration for auto scaling groups
resource "aws_launch_configuration" "myapp_lc" {
  name            = "myapp-lc-1"
  image_id        = "${var.web_ami}"
  instance_type   = "${var.ec2_instance_type}"
  key_name        = "${aws_key_pair.developer.key_name}"
  user_data       = "${file("scripts/install_httpd.sh")}"
  security_groups = ["${aws_security_group.allow_http.id}"]

  # iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
}

# Define Auto Scaling Group
resource "aws_autoscaling_group" "myapp_ASG" {
  name     = "myapp_ASG"
  max_size = 2
  min_size = 1

  # desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = ["${aws_elb.myapp_elb.name}"]
  force_delete              = true
  vpc_zone_identifier       = ["${aws_subnet.web_subnets.*.id}"]
  launch_configuration      = "${aws_launch_configuration.myapp_lc.name}"
}

resource "aws_autoscaling_policy" "AddInstancesPolicy" {
  name                   = "AddInstancesPolicy"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.myapp_ASG.name}"
}

resource "aws_autoscaling_policy" "RemoveInstancesPolicy" {
  name                   = "RemoveInstancesPolicy"
  scaling_adjustment     = -2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.myapp_ASG.name}"
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_ge_80" {
  alarm_name          = "avg_cpu_ge_80"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.myapp_ASG.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.AddInstancesPolicy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_le_30" {
  alarm_name          = "avg_cpu_le_30"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.myapp_ASG.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.RemoveInstancesPolicy.arn}"]
}
