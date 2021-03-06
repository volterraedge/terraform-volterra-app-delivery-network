locals {
  namespace = var.volterra_namespace_exists ? join("", data.volterra_namespace.this.*.name) : join("", volterra_namespace.this.*.name)
  hipster_manifest_content = templatefile(format("%s/manifest/hipster-adn.tpl", path.module), {
    namespace           = local.namespace
    frontend_domain_url = "http://frontend:80"
  })
  js_delay_list = var.disable_js_challenge ? [] : [
    {
      js_script_delay = var.js_script_delay
      cookie_expiry   = var.js_cookie_expiry
    }
  ]
}
