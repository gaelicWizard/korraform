# set variables in CLIENT_NAME.TFVARS file
variable "deployment" {
  description = "GitHub repo and name for each container to build and deploy"
  type        = map(map(string))
  default = {
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
}


variable "aws_access_key" {
  description = "Key name"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "Key secret"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "The GitHub Token to be used for the CodePipeline"
  type        = string
}
