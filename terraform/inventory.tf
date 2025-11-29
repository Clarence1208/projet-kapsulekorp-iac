resource "local_file" "ansible_inventory" {
  depends_on = [
    orbstack_linux_vm.staging_web,
    orbstack_linux_vm.staging_db,
    orbstack_linux_vm.production_web,
    orbstack_linux_vm.production_db,
  ]
  filename             = "../terraform-inventory.ini"
  file_permission      = "0644"
  directory_permission = "0755"
  content    = <<EOF
[staging-web]
%{for vm in orbstack_linux_vm.staging_web~}
${vm.name} ansible_host=${vm.name}.orb.local
%{endfor~}

[staging-db]
%{for vm in orbstack_linux_vm.staging_db~}
${vm.name} ansible_host=${vm.name}.orb.local
%{endfor~}

[production-web]
%{for vm in orbstack_linux_vm.production_web~}
${vm.name} ansible_host=${vm.name}.orb.local
%{endfor~}

[production-db]
%{for vm in orbstack_linux_vm.production_db~}
${vm.name} ansible_host=${vm.name}.orb.local
%{endfor~}

[web:children]
staging-web
production-web

[db:children]
staging-db
production-db

[all:children]
web
db

[production:children]
production-web
production-db

[staging:children]
staging-web
staging-db
EOF
}
