terraform {
  required_version = ">= 0.12.0"
}

variable "service_name" {
  type = "string"
}

variable "cluster_name" {
  type = "string"
}

variable "tags" {
  default = {}
}

variable "alarm_up_actions" {}
variable "alarm_down_actions" {}
variable "scale_up" {
  default = {
    cpu = {
      comparison_operator = ""
      metric_name         = ""
      evaluation_periods  = ""
      threshold           = ""
      period              = ""
      statistic           = ""
      alarm_actions       = []
    }
    memory = {
      comparison_operator = ""
      metric_name         = ""
      evaluation_periods  = ""
      threshold           = ""
      period              = ""
      statistic           = ""
      alarm_actions       = []
    }
  }
}

variable "scale_down" {
  default = {
    cpu = {
      comparison_operator = "LessThanThreshold"
      metric_name         = "CPUUtilization"
      evaluation_periods  = "2"
      threshold           = "50"
      period              = "60"
      statistic           = "Average"
      alarm_actions       = []
    }
    memory = {
      comparison_operator = "LessThanThreshold"
      metric_name         = "MemoryUtilization"
      evaluation_periods  = "2"
      threshold           = "50"
      period              = "60"
      statistic           = "Average"
      alarm_actions       = []
    }
  }
}

variable "cpu_scale_up_is_enabled" {
  default = false
}

variable "cpu_scale_down_is_enabled" {
  default = false
}

variable "memory_scale_up_is_enabled" {
  default = false
}

variable "memory_scale_down_is_enabled" {
  default = false
}

locals {
  compose_alarm_name_cpu_scale_up   = "${var.service_name}-cpu-scale-up"
  compose_alarm_name_cpu_scale_down = "${var.service_name}-cpu-scale-down"

  compose_alarm_name_memory_scale_up   = "${var.service_name}-memory-scale-up"
  compose_alarm_name_memory_scale_down = "${var.service_name}-memory-scale-down"

  scale_up = {
    cpu = {
      comparison_operator = "GreaterThanThreshold"
      metric_name         = "CPUUtilization"
      evaluation_periods  = "2"
      threshold           = "70"
      period              = "60"
      statistic           = "Average"
      alarm_actions       = []
    }
    memory = {
      comparison_operator = "GreaterThanThreshold"
      metric_name         = "MemoryUtilization"
      evaluation_periods  = "2"
      threshold           = "70"
      period              = "60"
      statistic           = "Average"
      alarm_actions       = []
    }
  }

  scale_down = {
    cpu = {
      comparison_operator = "LessThanThreshold"
      metric_name         = "CPUUtilization"
      evaluation_periods  = "2"
      threshold           = "50"
      period              = "60"
      statistic           = "Average"
      alarm_actions       = []
    }
    memory = {
      comparison_operator = "LessThanThreshold"
      metric_name         = "MemoryUtilization"
      evaluation_periods  = "2"
      threshold           = "50"
      period              = "60"
      statistic           = "Average"
      alarm_actions       = []
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_scale_up" {
  count               = var.cpu_scale_up_is_enabled == true ? 1 : 0
  alarm_name          = local.compose_alarm_name_cpu_scale_up
  comparison_operator = lookup(var.scale_up.cpu, "comparison_operator", lookup(local.scale_up.cpu, "comparison_operator"))
  metric_name         = lookup(var.scale_up.cpu, "metric_name", lookup(local.scale_up.cpu, "metric_name"))
  evaluation_periods  = lookup(var.scale_up.cpu, "evaluation_periods", lookup(local.scale_up.cpu, "evaluation_periods"))
  threshold           = lookup(var.scale_up.cpu, "threshold", lookup(local.scale_up.cpu, "threshold"))
  namespace           = "AWS/ECS"
  period              = lookup(var.scale_up.cpu, "period", lookup(local.scale_up.cpu, "period"))
  statistic           = lookup(var.scale_up.cpu, "statistic", lookup(local.scale_up.cpu, "statistic"))

  dimensions = {
    ServiceName = "${var.service_name}"
    ClusterName = "${var.cluster_name}"
  }

  alarm_actions = var.alarm_up_actions

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "cpu_scale_down" {
  count               = var.cpu_scale_down_is_enabled == true ? 1 : 0
  alarm_name          = local.compose_alarm_name_cpu_scale_down
  comparison_operator = lookup(var.scale_down.cpu, "comparison_operator", lookup(local.scale_down.cpu, "comparison_operator"))
  metric_name         = lookup(var.scale_down.cpu, "metric_name", lookup(local.scale_down.cpu, "metric_name"))
  evaluation_periods  = lookup(var.scale_down.cpu, "evaluation_periods", lookup(local.scale_down.cpu, "evaluation_periods"))
  threshold           = lookup(var.scale_down.cpu, "threshold", lookup(local.scale_down.cpu, "threshold"))
  namespace           = "AWS/ECS"
  period              = lookup(var.scale_down.cpu, "period", lookup(local.scale_down.cpu, "period"))
  statistic           = lookup(var.scale_down.cpu, "statistic", lookup(local.scale_down.cpu, "statistic"))

  dimensions = {
    ServiceName = "${var.service_name}"
    ClusterName = "${var.cluster_name}"
  }

  alarm_actions = var.alarm_down_actions

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "memory_scale_up" {
  count               = var.memory_scale_up_is_enabled == true ? 1 : 0
  alarm_name          = local.compose_alarm_name_memory_scale_up
  comparison_operator = lookup(var.scale_up.memory, "comparison_operator", lookup(local.scale_up.memory, "comparison_operator"))
  metric_name         = lookup(var.scale_up.memory, "metric_name", lookup(local.scale_up.memory, "metric_name"))
  evaluation_periods  = lookup(var.scale_up.memory, "evaluation_periods", lookup(local.scale_up.memory, "evaluation_periods"))
  threshold           = lookup(var.scale_up.memory, "threshold", lookup(local.scale_up.memory, "threshold"))
  namespace           = "AWS/ECS"
  period              = lookup(var.scale_up.memory, "period", lookup(local.scale_up.memory, "period"))
  statistic           = lookup(var.scale_up.memory, "statistic", lookup(local.scale_up.memory, "statistic"))

  dimensions = {
    ServiceName = "${var.service_name}"
    ClusterName = "${var.cluster_name}"
  }

  alarm_actions = var.alarm_up_actions

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "memory_scale_down" {
  count               = var.memory_scale_down_is_enabled == true ? 1 : 0
  alarm_name          = local.compose_alarm_name_memory_scale_down
  comparison_operator = lookup(var.scale_down.memory, "comparison_operator", lookup(local.scale_down.memory, "comparison_operator"))
  metric_name         = lookup(var.scale_down.memory, "metric_name", lookup(local.scale_down.memory, "metric_name"))
  evaluation_periods  = lookup(var.scale_down.memory, "evaluation_periods", lookup(local.scale_down.memory, "evaluation_periods"))
  threshold           = lookup(var.scale_down.memory, "threshold", lookup(local.scale_down.memory, "threshold"))
  namespace           = "AWS/ECS"
  period              = lookup(var.scale_down.memory, "period", lookup(local.scale_down.memory, "period"))
  statistic           = lookup(var.scale_down.memory, "statistic", lookup(local.scale_down.memory, "statistic"))

  dimensions = {
    ServiceName = "${var.service_name}"
    ClusterName = "${var.cluster_name}"
  }

  alarm_actions = var.alarm_down_actions

  tags = var.tags
}