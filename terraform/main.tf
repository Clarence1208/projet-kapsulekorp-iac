# Staging Environment

resource "orbstack_linux_vm" "staging_web" {
  count  = var.staging_web_count
  name   = "${var.project_name}-staging-web-${count.index + 1}"
  distro = var.distro

  provisioner "local-exec" {
    command = "orb -m ${self.name} --shell \"mkdir -p ~/.ssh && echo '$(cat ~/.ssh/id_ed25519.pub)' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys\""
  }
}

resource "orbstack_linux_vm" "staging_db" {
  count  = var.staging_db_count
  name   = "${var.project_name}-staging-db-${count.index + 1}"
  distro = var.distro

  provisioner "local-exec" {
    command = "orb -m ${self.name} --shell \"mkdir -p ~/.ssh && echo '$(cat ~/.ssh/id_ed25519.pub)' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys\""
  }
}

# Production Environment

resource "orbstack_linux_vm" "production_web" {
  count  = var.production_web_count
  name   = "${var.project_name}-prod-web-${count.index + 1}"
  distro = var.distro

  provisioner "local-exec" {
    command = "orb -m ${self.name} --shell \"mkdir -p ~/.ssh && echo '$(cat ~/.ssh/id_ed25519.pub)' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys\""
  }
}

resource "orbstack_linux_vm" "production_db" {
  count  = var.production_db_count
  name   = "${var.project_name}-prod-db-${count.index + 1}"
  distro = var.distro

  provisioner "local-exec" {
    command = "orb -m ${self.name} --shell \"mkdir -p ~/.ssh && echo '$(cat ~/.ssh/id_ed25519.pub)' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys\""
  }
}
