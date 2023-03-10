/**/
terraform {
  cloud {
    workspaces {
      tags = ["korraform"]
    }
  }
} /**/

module "vpc" {
  source  = "../modules/vpc"
  name    = local.project_name
  subnets = local.subnets
  region  = local.location
}

/*
module "ecs" {
	source = "../modules/ecs"
	vpc_id = module.vpc.vpc_id
	region = local.location
	container_group = "Korro"
	container_name = "Legend"
	subnets = local.subnets
	lb_target_group = module.elb.aws_lb_target_group.?.*.arn
}/**/

module "ecr" {
  source   = "../modules/ecr"
  ecr_name = "${local.project_name}-${terraform.workspace}"
}

module "codepipeline" {
  source                  = "../modules/codepipeline"
  for_each                = local.deployment
  repository_in           = each.value.repo
  branch_in               = each.value.branch
  name_in                 = each.key
  codebuild_project_name  = module.codebuild.codebuild_project_name
  s3_bucket_name          = module.s3.s3_bucket
  codestar_connection_arn = module.codestar_connection.codestar_arn
}

module "codebuild" {
  source                 = "../modules/codebuild"
  codebuild_project_name = local.project_name
  environment_variables  = local.environment_variables
  codebuild_params       = local.codebuild_params
}

module "KorraStar" {
  source = "../modules/codestar"
}

module "s3" {
  source = "../modules/s3"
}
