# --- ecs/outputs.tf ---

output "svc_discovery_arn" {
  value = aws_service_discovery_service.movies_svc_discovery.arn
}