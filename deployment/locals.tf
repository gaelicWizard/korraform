locals {
  location     = "us-east-1"
  project_name = "korraform"

  deployment = {
    Sample = {
      repo   = "ilsaTi/docker-simple-webpage"
      branch = "master"
    }
    Example = {
      repo   = "gaelicWizard/korraform"
      branch = "main"
    }
    Repo-3 = {
      repo   = "GitHub-Account-Name/Repo-3-Name"
      branch = "main"
    }
    Repo-4 = {
      repo   = "GitHub-Account-Name/Repo-4-Name"
      branch = "main"
    }
  }

  codebuild_params = {
    "NAME"  = "codebuild-demo-terraform"
    image   = "aws/codebuild/standard:4.0"
    type    = "LINUX_CONTAINER"
    compute = "BUILD_GENERAL1_SMALL"
    cred    = "CODEBUILD"
  }

  environment_variables = {
    "AWS_DEFAULT_REGION" = local.location
    "IMAGE_REPO_NAME"    = "demo"
    "IMAGE_TAG"          = "latest"
  }
}
