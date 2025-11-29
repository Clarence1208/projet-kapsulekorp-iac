# Staging Environment

resource "orbstack_linux_vm" "staging_web" {
  count  = var.staging_web_count
  name   = "${var.project_name}-staging-web-${count.index + 1}"
  distro = var.distro

  provisioner "local-exec" {
    command = "orb -m ${self.name} --shell \"sudo apt update && sudo apt upgrade -y && sudo apt install -y openssh-server\""
  }
}

resource "orbstack_linux_vm" "staging_db" {
  count  = var.staging_db_count
  name   = "${var.project_name}-staging-db-${count.index + 1}"
  distro = var.distro

  provisioner "local-exec" {
    command = "orb -m ${self.name} --shell \"sudo apt update && sudo apt upgrade -y && sudo apt install -y openssh-server\""
  }
}

# Production Environment

resource "orbstack_linux_vm" "production_web" {
  count  = var.production_web_count
  name   = "${var.project_name}-prod-web-${count.index + 1}"
  distro = var.distro

  provisioner "local-exec" {
    command = "orb -m ${self.name} --shell \"sudo apt update && sudo apt upgrade -y && sudo apt install -y openssh-server\""
  }
}

resource "orbstack_linux_vm" "production_db" {
  count  = var.production_db_count
  name   = "${var.project_name}-prod-db-${count.index + 1}"
  distro = var.distro

  provisioner "local-exec" {
    command = "orb -m ${self.name} --shell \"sudo apt update && sudo apt upgrade -y && sudo apt install -y openssh-server\""
  }
}
