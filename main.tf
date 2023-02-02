/* Create a CodePipeline to:
 -  retrieve and build a Docker image, 
 - push it to ECR, and 
 - deploy it to ECS with a load balancer.
 */

/* TEMP */
module "vpc" {
  source         = "./modules/vpc"
  name           = local.project_name
  network_prefix = local.network_prefix
  network_suffix = ".0/${local.network_mask}"
  subnet_mask    = local.subnet_mask
  region         = local.region
}
# https://medium.com/@maneetkum/create-subnet-per-availability-zone-in-aws-through-terraform-ea81d1ec1883

/* TEMP */

module "KorraLoad" {
  source       = "./modules/alb"
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.subnet_ids
  project_name = local.project_name
  certificate  = "" #local.certificate/**/
}

/*module "KorraCert" {
  source      = "./modules/acm"
  domain_name = "Legend.SpeizerSoftware.io"
}/**/

module "Korrapod" {
  source         = "./modules/ecs"
  project_name   = local.project_name
  region         = local.region
  vpc_id         = module.vpc.vpc_id
  target_groups  = module.KorraLoad.group_arns
  listener       = module.KorraLoad.listener
  repository_url = module.KorraRepo.url
  containers     = var.deployment
  subnets        = module.vpc.subnet_ids
}

module "Korraline" {
  source              = "./modules/codepipeline"
  project_name        = local.project_name
  codebuild_arn       = module.KorraBuild.arn
  codebuild_name      = module.KorraBuild.name
  codedeploy_arns     = module.Korraploy.arns
  codedeploy_app      = module.Korraploy.app
  codedeploy_group    = module.Korraploy.group
  codestar_connection = module.KorraStar.codestar_arn
  containers          = var.deployment
  region              = local.region
  ecr                 = module.KorraRepo.arn
} /**/

module "Korraploy" {
  source             = "./modules/codedeploy"
  project_name       = local.project_name
  task_role_arn      = module.Korrapod.task_role
  execution_role_arn = module.Korrapod.execution_role
  s3_bucket          = module.Korraline.bucket_name
  listener_arn       = module.KorraLoad.listener
  ecs_service        = module.Korrapod.service_name
  ecs_cluster        = module.Korrapod.cluster_name
  blue_name          = module.KorraLoad.group_names[0]
  green_name         = module.KorraLoad.group_names[1]
}

module "KorraBuild" {
  source                = "./modules/codebuild"
  project_name          = local.project_name
  image_name            = "CodePipeline"
  container_repo        = module.KorraRepo.url
  environment_variables = local.environment_variables
  codebuild_params      = local.codebuild_params
  region                = local.region
  bucket                = module.Korraline.bucket_name
  ecr_arn               = module.KorraRepo.arn
  ecs_arn               = module.Korrapod.arn
  task_definition       = module.Korrapod.tasks
} /**/

module "KorraStar" {
  source       = "./modules/codestar"
  project_name = local.project_name
}

module "KorraRepo" {
  source       = "./modules/ecr"
  project_name = local.project_name
}
