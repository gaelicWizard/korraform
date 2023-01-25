/*
 */
resource "aws_codepipeline" "Korraline" {
  for_each = local.containers
  name     = "${var.project_name}/${each.key}"
  role_arn = aws_iam_role.Korraline.arn

  artifact_store {
    location = aws_s3_bucket.Korraline.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connection
        FullRepositoryId = "${each.value.repo}"
        BranchName       = "${each.value.branch}"
      }
    }
  }

  stage {
    name = "Build"


    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${var.codebuild_project_name}"
      }
    }
  }

  stage {
    name = "Manual_Approval"
    action {
      name     = "Manual-Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "CreateChangeSet"
      version         = "1"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["build_output"]
      run_order       = 1

      configuration = {
        ActionMode    = "CHANGE_SET_REPLACE"
        StackName     = "${each.key}"
        ChangeSetName = "${each.key}-changes"
        RoleArn       = aws_iam_role.codepipeline.arn
        TemplatePath  = "build_output::outputtemplate.yml"
      }
    }

    action {
      name             = "DeployChangeSet"
      version          = "1"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CloudFormation"
      output_artifacts = ["cf_artifacts"]
      run_order        = 2

      configuration = {
        ActionMode    = "CHANGE_SET_EXECUTE"
        StackName     = "${each.key}"
        ChangeSetName = "${each.key}-changes"
      }
    }
  }
}
