# --- root/outputs.tf ---

### networking ###
output "subnet_id_1a" {
  value = module.networking.subnet_id_1a
}


# ### ecr ###
output "repos_urls" {
  value = module.ecr.repos_urls
}


# ### API Gateway ###
output "invoke_url" {
  value = module.apiGateway.invoke_url
}


# ### Alb ###
output "lb_url" {
  value = module.lb.lb_url
}