output "adn_app_url" {
  description = "Domain VIP to access the application, running on ADN"
  value       = format("https://%s", var.app_domain)
}
