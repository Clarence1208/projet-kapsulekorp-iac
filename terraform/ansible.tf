resource "null_resource" "ansible_run" {
  depends_on = [local_file.ansible_inventory]

  triggers = {
    # Always run this resource
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -i terraform-inventory.ini --ask-vault-pass ../playbook/site-deployment.yml"
    working_dir = path.module
  }
}
