# --- apiGateway/outputs.tf ---

output "invoke_url" {
  value = aws_apigatewayv2_stage.stage.invoke_url
}