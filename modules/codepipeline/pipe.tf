/* AWS CodePipeline:
 * - Get source from CodeStar Connection,
 * - Build with CodeBuild,
 * - Deploy through CodeDeploy.
 *
 * https://docs.aws.amazon.com/codepipeline/latest/userguide/tutorials-ecs-ecr-codedeploy.html#tutorials-ecs-ecr-codedeploy-taskdefinition
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
      namespace        = "SourceVariables"
      output_artifacts = ["source_repo"]

      configuration = {
        ConnectionArn        = var.codestar_connection
        FullRepositoryId     = "${each.value.repo}"
        BranchName           = "${each.value.branch}"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
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
            name  = "TEST_VAR"
            value = lower("${each.key}")
            type  = "PLAINTEXT"
          },
          {
            name  = "COMMIT_ID"
            value = "#{SourceVariables.BranchName}"
            type  = "PLAINTEXT"
          },
          {
            name  = "BRANCH_NAME"
            value = "#{SourceVariables.BranchName}"
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
    /* https://docs.aws.amazon.com/codepipeline/latest/userguide/file-reference.html#file-reference-ecs-bluegreen */

    action {
      name     = "YOLO"
      category = "Deploy"
      owner    = "AWS"
      provider = "CodeDeployToECS"
      version  = "1"
      input_artifacts = [
        /*"source_repo",/**/
        "built_image"
      ]

      configuration = {
        ApplicationName     = var.codedeploy_app
        DeploymentGroupName = var.codedeploy_group

        AppSpecTemplateArtifact        = "built_image"
        AppSpecTemplatePath            = "flatspec.yaml"
        TaskDefinitionTemplateArtifact = "built_image"
        TaskDefinitionTemplatePath     = "flattask.json"

        /*Image1ArtifactName  = "built_image"
        Image1ContainerName = "IMAGE1_NAME"/**/
      }
    }
  }
}
