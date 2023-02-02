/* AWS CodePipeline:
 * - Get source from CodeStar Connection,
 * - Build with CodeBuild,
 * - Deploy through CodeDeploy.
 */
resource "aws_codepipeline" "Korraline" {
  for_each = var.containers
  name     = "${var.project_name}.${each.key}"
  role_arn = aws_iam_role.Korraline.arn

  artifact_store {
    location = aws_s3_bucket.Korraline.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Code"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_repo"]

      configuration = {
        ConnectionArn    = var.codestar_connection
        FullRepositoryId = "${each.value.repo}"
        BranchName       = "${each.value.branch}"
      }
    }

    action {
      name             = "Repository"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["image_repo"]
      configuration = {
        RepositoryName = var.ecr_name
        ImageTag       = "latest"
      }
    }
  }

  stage {
    name = "Build"


    action {
      name             = "Builder"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_repo"]
      output_artifacts = ["built_image"]
      version          = "1"

      configuration = {
        ProjectName = "${var.codebuild_name}"
        EnvironmentVariables = jsonencode([
          {
            name  = "_IMAGE_NAME"
            value = lower("${each.key}")
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }

  stage {
    name = "Manual_Approval"
    action {
      name     = "Blame"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      name     = "YOLO"
      category = "Deploy"
      owner    = "AWS"
      provider = "CodeDeployToECS"
      version  = "1"
      input_artifacts = [
        "source_repo",
        "image_repo",
        "built_image"
      ]

      configuration = {
        ApplicationName     = var.codedeploy_app
        DeploymentGroupName = var.codedeploy_group

        AppSpecTemplateArtifact        = "image_repo"
        AppSpecTemplatePath            = "modules/codedeploy/appspec.yaml"
        TaskDefinitionTemplateArtifact = "built_image"
        TaskDefinitionTemplatePath     = "taskdef.json"

        Image1ArtifactName  = "built_image"
        Image1ContainerName = "example"
      }
    }
  }
}
