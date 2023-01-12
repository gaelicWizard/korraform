locals {
  location     = "us-east-1"
  project_name = "korraform"

  subnets = {
    "${local.location}-air" = "172.16.0.0/21"
    "${local.location}-fire" = "172.16.8.0/21"
    "${local.location}-water" = "172.16.16.0/21"
  }

  deployment = {
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
    image   = "aws/codebuild/standard:4.0"
    type    = "LINUX_CONTAINER"
    compute = "BUILD_GENERAL1_SMALL"
    cred    = "CODEBUILD"
  }

  environment_variables = {
    "AWS_DEFAULT_REGION" = local.location
    "IMAGE_REPO_NAME"    = local.project_name
    "IMAGE_TAG"          = "latest"
  }
}
