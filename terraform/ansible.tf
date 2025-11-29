resource "null_resource" "ansible_run" {
  depends_on = [local_file.ansible_inventory]

  triggers = {
    # Always run this resource
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "ansible-playbook -i terraform-inventory.ini --vault-password-file <(echo $ANSIBLE_VAULT_PASSWORD) playbook/site-deployment.yml"
    working_dir = "${path.module}/.."
    environment = {
      ANSIBLE_VAULT_PASSWORD = var.vault_password
    }
  }
}
