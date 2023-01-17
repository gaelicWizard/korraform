resource "aws_codebuild_project" "CodeBuild_Project" {
  name          = var.image_name
  service_role = aws_iam_role.codebuildrole.arn

  artifacts {
    name                   = var.image_name
    override_artifact_name = true
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  source {
    git_clone_depth = 1
    type            = "CODEPIPELINE"
		buildspec       = file("buildspec.yaml")
  }

  environment {
    image                       = var.codebuild_params.image
    type                        = var.codebuild_params.type
    compute_type                = var.codebuild_params.compute
    image_pull_credentials_type = var.codebuild_params.cred
    privileged_mode             = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.default.account_id
    }
		
		environment_variable {
			name = "IMAGE_REPO_NAME"
			value = "${var.project_name}/${var.image_name}"
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
      status      = "ENABLED"
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status = "DISABLED"
    }
  }
}

output "image_name" {
  value = var.image_name
}

data "aws_caller_identity" "default" {}
