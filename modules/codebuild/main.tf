resource "aws_codebuild_project" "CodeBuild_Project" {
    name = var.codebuild_project_name
    build_timeout = 120
#    encryption_key         = aws_kms_key.codebuild.arn
    service_role           = aws_iam_role.codebuildrole.arn

    artifacts {
        name                   = var.codebuild_project_name
        override_artifact_name = false
        packaging              = "NONE"
        type                   = "CODEPIPELINE"
    }

    source {
        git_clone_depth     = 0
        type                = "CODEPIPELINE"
    }

  environment {
    image                       = var.codebuild_params.image
    type                        = var.codebuild_params.type
    compute_type                = var.codebuild_params.compute
    image_pull_credentials_type = var.codebuild_params.cred
    privileged_mode             = true

    environment_variable {
        name  = "AWS_ACCOUNT_ID"
        value  = "${data.aws_caller_identity.default.account_id}"
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
            status = "ENABLED"
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status = "DISABLED"
    }
  }
}

output "codebuild_project_name" {
  value = var.codebuild_project_name
}

data "aws_caller_identity" "default" {}
