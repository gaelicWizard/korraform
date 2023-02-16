# set variables in CLIENT_NAME.TFVARS file
locals {
  project_name = var.project_name != "" ? var.project_name : terraform.workspace
  environment  = terraform.workspace
  region       = var.aws_region

  containers     = var.deployment
  network_prefix = "10.172.9"
  network_mask   = "24"
  subnet_mask    = "28" # 16 subnets of 16 hosts

  codebuild_params = {
    image     = "aws/codebuild/standard:5.0"
    type      = "LINUX_CONTAINER"
    compute   = "BUILD_GENERAL1_SMALL"
    cred      = "CODEBUILD"
    priv_mode = true
  }

  environment_variables = {
    "AWS_DEFAULT_REGION" = local.region
    "IMAGE_REPO_BASE"    = local.project_name
    "IMAGE_TAG"          = "latest" # ¿git commit hash?
  }

  subnets = module.vpc.subnets
}
