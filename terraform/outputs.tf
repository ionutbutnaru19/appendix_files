output "Primary_public_ip" {
  value = module.Primary_Bastion.public_ip
}

output "Failover_public_ip" {
  value = module.Failover_Bastion.public_ip
}

output "Load_balancer_dns" {
  value = module.load_balancer.dns_name
}
