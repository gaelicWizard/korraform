/* AWS CodeDeploy
 * 
 */
resource "aws_codedeploy_app" "Korraploy" {
  compute_platform = "ECS"
  name             = var.project_name
}

resource "aws_codedeploy_deployment_group" "Korraploy" {
  app_name               = aws_codedeploy_app.Korraploy.name
  deployment_group_name  = var.project_name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.Korraploy.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster
    service_name = var.ecs_service
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${var.listener_arn}"]
      }

      target_group {
        name = var.blue_name
      }

      target_group {
        name = var.green_name
      }
    }
  }
}
