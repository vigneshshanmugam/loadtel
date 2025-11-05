provider "elasticstack" {
  elasticsearch {
    username  = ec_observability_project.loadsingle.credentials.username
    password  = ec_observability_project.loadsingle.credentials.password
    endpoints = [ec_observability_project.loadsingle.endpoints.elasticsearch]
  }
}

resource "elasticstack_elasticsearch_security_api_key" "api_key" {
  name = "project api key"
  role_descriptors = jsonencode({})
}

output "api_key" {
  value     = elasticstack_elasticsearch_security_api_key.api_key
  sensitive = true
}
