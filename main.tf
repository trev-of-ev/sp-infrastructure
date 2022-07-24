resource "aws_ecs_cluster" "sp_container_cluster" {
  name = "sp-container-cluster"
}

resource "aws_autoscaling_group" "sp-autoscale" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id = aws_launch_template.sp-template.id  
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "sp_cap_provider" {
  name = "sp-cap-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.sp-autoscale.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
}

resource "aws_launch_template" "sp-template" {
  name_prefix   = "sp-template"
  image_id      = aws_ami.sp_ami.id
  instance_type = "t3.nano"
}

resource "aws_ami" "sp_ami" {
  name = "sp-ami"
  root_device_name = "/dev/sda1"
}