# --- apiGateway/main.tf ---

resource "aws_apigatewayv2_vpc_link" "VPC_LINK" {
  name               = var.VPC_LINK_Name
  security_group_ids = [var.sg_id]
  subnet_ids         = [var.subnet_id]
}

resource "local_file" "OpenAPI_Template" {
  content = templatefile("${path.module}/openapi_template.yml", {
    ECS_SRV_ARN             = aws_apigatewayv2_vpc_link.VPC_LINK.id
    API_GATEWAY_VPC_LINK_ID = var.API_GATEWAY_VPC_LINK_ID
  })

  filename = "${path.module}/openapi.yml"
}

resource "aws_apigatewayv2_api" "API" {
  name          = var.API_Name
  protocol_type = var.API_Protocol
  body          = file("${path.module}/openapi.yml")

  depends_on = [
    local_file.OpenAPI_Template
  ]
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.API.id
  name        = "$default"
  auto_deploy = true
}

