resource "aws_autoscaling_group" "webapp_autoscaling_group" {
  launch_configuration = var.launch_config
  min_size = 2
  max_size = 4
  desired_capacity = 2
  vpc_zone_identifier = var.subnets
  target_group_arns = var.target_group
  health_check_type = "ELB"
  health_check_grace_period = 60
  tag {
    key = "Name"
    value = "webserver"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scaling_out_policy" {
  name = "ScalingOutPolicy"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.webapp_autoscaling_group.name
  cooldown = 60
}
resource "aws_autoscaling_policy" "scaling_in_policy" {
  name = "ScalingInPolicy"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.webapp_autoscaling_group.name
  cooldown = 60
}
resource "aws_cloudwatch_metric_alarm" "autoscaling_alarm" {
  alarm_name = "ScalingInOrOutAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Average"
  threshold = 25
  alarm_description = "Scaling in or out based on average CPU utilization"
  alarm_actions = [aws_autoscaling_policy.scaling_out_policy.arn]
  ok_actions = [aws_autoscaling_policy.scaling_in_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_autoscaling_group.name
  }
}
