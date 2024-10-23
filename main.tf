# Cargar los YAMLs
locals {
  local_repositories  = yamldecode(file("${path.module}/local_repositories.yaml"))
  remote_repositories = yamldecode(file("${path.module}/remote_repositories.yaml"))
  virtual_repositories = yamldecode(file("${path.module}/virtual_repositories.yaml"))
  users               = yamldecode(file("${path.module}/users.yaml"))
  groups              = yamldecode(file("${path.module}/groups.yaml"))
}

provider "artifactory" {
  url      = "https://<your-artifactory-url>/artifactory"
  username = var.artifactory_username
  password = var.artifactory_password
}

# Crear Repositorios Locales
resource "artifactory_local_repository" "local_repos" {
  count            = length(local.local_repositories.repositories)
  key              = local.local_repositories.repositories[count.index].key
  package_type     = local.local_repositories.repositories[count.index].package_type
  description      = local.local_repositories.repositories[count.index].description
  repo_layout_ref  = local.local_repositories.repositories[count.index].repo_layout_ref
}

# Crear Repositorios Remotos
resource "artifactory_remote_repository" "remote_repos" {
  count            = length(local.remote_repositories.repositories)
  key              = local.remote_repositories.repositories[count.index].key
  package_type     = local.remote_repositories.repositories[count.index].package_type
  url              = local.remote_repositories.repositories[count.index].url
  repo_layout_ref  = local.remote_repositories.repositories[count.index].repo_layout_ref
}

# Crear Repositorios Virtuales
resource "artifactory_virtual_repository" "virtual_repos" {
  count            = length(local.virtual_repositories.repositories)
  key              = local.virtual_repositories.repositories[count.index].key
  package_type     = local.virtual_repositories.repositories[count.index].package_type
  repositories     = local.virtual_repositories.repositories[count.index].repositories
}

# Gestión de Grupos desde YAML
resource "artifactory_group" "groups" {
  count             = length(local.groups.groups)
  name              = local.groups.groups[count.index].name
  description       = local.groups.groups[count.index].description
  admin_privileges  = local.groups.groups[count.index].admin_privileges
}

# Gestión de Usuarios desde YAML
resource "artifactory_user" "users" {
  count            = length(local.users.users)
  name             = local.users.users[count.index].name
  email            = local.users.users[count.index].email
  groups           = local.users.users[count.index].groups
  admin            = local.users.users[count.index].admin
}

# Configuración de Permisos
resource "artifactory_permission_target" "permissions" {
  name = "dev-permission"

  repo {
    includes_pattern = "**"
    repositories     = ["my-local-repo-1"]
    actions {
      users {
        name        = "developer_user"
        permissions = ["read", "download"]
      }
    }
  }
}

# Configuración de Políticas de Retención
resource "artifactory_cleanup_policy" "cleanup_policies" {
  name      = "cleanup-old-artifacts"
  enabled   = true
  max_days  = 30
  repo_keys = ["my-local-repo-1", "my-remote-repo-1"]
}

# Configuración de Backups
resource "artifactory_backup" "backups" {
  key               = "daily-backup"
  enabled           = true
  cron_exp          = "0 0 * * *"
  retention_period  = 30
  include_repos     = ["my-local-repo-1"]
}

# Integración de Proxy
resource "artifactory_proxy" "proxy" {
  key          = "corporate-proxy"
  host         = "proxy.mycompany.com"
  port         = 8080
  username     = var.proxy_username
  password     = var.proxy_password
}
