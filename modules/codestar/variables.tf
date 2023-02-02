/*
 */
variable "project_name" {
  description = "Name for GitHub connection"
  type        = string
}

variable "connection_type" {
  description = "Name of provider for connection, e.g. 'GitHub'"
  type        = string
  default     = "GitHub"
}
