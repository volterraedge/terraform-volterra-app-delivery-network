data "volterra_namespace" "this" {
  count = var.volterra_namespace_exists ? 1 : 0
  name  = var.volterra_namespace
}

resource "volterra_namespace" "this" {
  count = var.volterra_namespace_exists ? 0 : 1
  name  = var.volterra_namespace
}

resource "volterra_virtual_k8s" "this" {
  name      = format("%s-vk8s", var.adn_name)
  namespace = local.namespace

  vsite_refs {
    name      = "ves-io-all-res"
    namespace = "shared"
    tenant    = "ves-io"
  }

  provisioner "local-exec" {
    command = "sleep 100s"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 20s"
  }
}

resource "volterra_api_credential" "this" {
  name                  = substr(volterra_virtual_k8s.this.id, 1, 30)
  api_credential_type   = "KUBE_CONFIG"
  expiry_days           = 10
  virtual_k8s_namespace = local.namespace
  virtual_k8s_name      = format("%s-vk8s", var.adn_name)
  lifecycle {
    ignore_changes = [
      name
    ]
  }
}

resource "local_file" "this_kubeconfig" {
  content  = base64decode(volterra_api_credential.this.data)
  filename = format("%s/_output/hipster_adn_vk8s_kubeconfig", path.root)
}

resource "local_file" "hipster_manifest" {
  content  = local.hipster_manifest_content
  filename = format("%s/_output/hipster-adn.yaml", path.root)
}

resource "null_resource" "apply_manifest" {
  depends_on = [local_file.this_kubeconfig, local_file.hipster_manifest]
  triggers = {
    manifest_sha1 = sha1(local.hipster_manifest_content)
  }
  provisioner "local-exec" {
    command = "kubectl apply -f _output/hipster-adn.yaml"
    environment = {
      KUBECONFIG = format("%s/_output/hipster_adn_vk8s_kubeconfig", path.root)
    }
  }
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f _output/hipster-adn.yaml --ignore-not-found=true"
    environment = {
      KUBECONFIG = format("%s/_output/hipster_adn_vk8s_kubeconfig", path.root)
    }
    on_failure = continue
  }
}
