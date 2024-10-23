import unittest
from your_script_name import generate_import_and_tf_code

class TestGenerateImportAndTfCode(unittest.TestCase):

    def setUp(self):
        # Datos de prueba para los repositorios
        self.repositories = [
            {
                "key": "my-local-repo-1",
                "packageType": "maven",
                "description": "A local Maven repository",
                "repoLayoutRef": "maven-2-default"
            },
            {
                "key": "my-remote-repo-1",
                "packageType": "npm",
                "description": "A remote NPM repository",
                "repoLayoutRef": "npm-default",
                "url": "https://registry.npmjs.org"
            }
        ]

    def test_generate_import_commands(self):
        # Generar comandos y bloques Terraform
        import_commands, tf_code = generate_import_and_tf_code(self.repositories)

        # Verificar que los comandos de importación son correctos
        expected_import_commands = [
            "terraform import artifactory_local_repository.my-local-repo-1 my-local-repo-1",
            "terraform import artifactory_remote_repository.my-remote-repo-1 my-remote-repo-1"
        ]
        self.assertEqual(import_commands, expected_import_commands)

    def test_generate_tf_code(self):
        # Generar comandos y bloques Terraform
        import_commands, tf_code = generate_import_and_tf_code(self.repositories)

        # Verificar que los bloques Terraform son correctos para el repositorio local
        expected_tf_code_local = '''
resource "artifactory_local_repository" "my-local-repo-1" {
  key             = "my-local-repo-1"
  package_type    = "maven"
  description     = "A local Maven repository"
  repo_layout_ref = "maven-2-default"
}
            '''

        # Verificar que los bloques Terraform son correctos para el repositorio remoto
        expected_tf_code_remote = '''
resource "artifactory_remote_repository" "my-remote-repo-1" {
  key             = "my-remote-repo-1"
  package_type    = "npm"
  description     = "A remote NPM repository"
  repo_layout_ref = "npm-default"
  url             = "https://registry.npmjs.org"
}
            '''

        # Verificar que los bloques son correctos
        self.assertEqual(tf_code[0].strip(), expected_tf_code_local.strip())
        self.assertEqual(tf_code[1].strip(), expected_tf_code_remote.strip())

if __name__ == '__main__':
    unittest.main()
