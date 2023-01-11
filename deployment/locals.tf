locals {
  location     = "us-east-1"
  project_name = "Legend-of-Korra"

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
}
