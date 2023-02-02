/* AWS CodeBuild instance to build a Docker image.
 * INPUT: whatever repository CodePipeline passes in.
 * OUTPUT: upload image to ECR, then pass back to CodePipeline.
 */
resource "aws_codebuild_project" "KorraBuild" {
  name         = var.project_name
  service_role = aws_iam_role.KorraBuild.arn

  source {
    git_clone_depth = 1
    git_submodules_config {
      fetch_submodules = true
    }
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec.rendered
  }

  artifacts {
    name                   = var.image_name
    override_artifact_name = true
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    image                       = var.codebuild_params.image
    type                        = var.codebuild_params.type
    compute_type                = var.codebuild_params.compute
    image_pull_credentials_type = var.codebuild_params.cred
    privileged_mode             = var.codebuild_params.priv_mode

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.default.account_id
    }

    environment_variable {
      name  = "IMAGE_NAME"
      value = var.image_name
    }

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      status      = "ENABLED" # var.cloudwatch_params.status
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status = "DISABLED"
    }
  }
}

data "template_file" "buildspec" {
  template = file("${path.module}/buildspec.yaml")
  vars = {
    REPOSITORY_URI = "https://${var.container_repo}"
    IMAGE_NAME     = var.image_name
    # CODEBUILD_RESOLVED_SOURCE_VERSION
  }
}

data "aws_caller_identity" "default" {}
