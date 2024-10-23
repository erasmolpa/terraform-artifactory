variable "artifactory_username" {
  description = "Username for Artifactory"
  type        = string
}

variable "artifactory_password" {
  description = "Password for Artifactory"
  type        = string
  sensitive   = true
}
variable "artifactory_url" {
  description = "Artifactory Endpoint"
  type        = string
}
variable "proxy_username" {
  description = "Proxy username"
  type        = string
}

variable "proxy_password" {
  description = "Proxy password"
  type        = string
  sensitive   = true
}
