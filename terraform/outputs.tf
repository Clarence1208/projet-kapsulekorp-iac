output "staging_web_hosts" {
  value = [for vm in orbstack_machine.staging_web : vm.name]
}

output "staging_db_hosts" {
  value = [for vm in orbstack_machine.staging_db : vm.name]
}

output "production_web_hosts" {
  value = [for vm in orbstack_machine.production_web : vm.name]
}

output "production_db_hosts" {
  value = [for vm in orbstack_machine.production_db : vm.name]
}
