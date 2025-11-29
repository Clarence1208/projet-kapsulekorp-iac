output "staging_web_hosts" {
  value = [for vm in orbstack_linux_vm.staging_web : vm.name]
}

output "staging_db_hosts" {
  value = [for vm in orbstack_linux_vm.staging_db : vm.name]
}

output "production_web_hosts" {
  value = [for vm in orbstack_linux_vm.production_web : vm.name]
}

output "production_db_hosts" {
  value = [for vm in orbstack_linux_vm.production_db : vm.name]
}
