import json

def generate_import_and_tf_code(repositories):
    import_commands = []
    tf_code = []

    for repo in repositories:
        repo_key = repo['key']
        package_type = repo['packageType']
        description = repo.get('description', '')
        repo_layout_ref = repo.get('repoLayoutRef', '')

        # Determinar el tipo de repositorio y ajustar los bloques Terraform
        if 'url' in repo:
            # Repositorio remoto
            import_commands.append(f'terraform import artifactory_remote_repository.{repo_key} {repo_key}')
            tf_code.append(f'''
resource "artifactory_remote_repository" "{repo_key}" {{
  key             = "{repo_key}"
  package_type    = "{package_type}"
  description     = "{description}"
  repo_layout_ref = "{repo_layout_ref}"
  url             = "{repo['url']}"
}}
            ''')
        else:
            # Repositorio local
            import_commands.append(f'terraform import artifactory_local_repository.{repo_key} {repo_key}')
            tf_code.append(f'''
resource "artifactory_local_repository" "{repo_key}" {{
  key             = "{repo_key}"
  package_type    = "{package_type}"
  description     = "{description}"
  repo_layout_ref = "{repo_layout_ref}"
}}
            ''')

    return import_commands, tf_code
