data "template_file" "traefik" {
  template = file("${path.module}/values.yml.tpl")

  vars = {
    api_dns_label = var.traefik_config.api_dns_label
  }
}

resource "kubernetes_namespace" "edge" {
  metadata {
    name = "edge"
  }
}

resource "helm_release" "ingress" {
  depends_on       = [kubernetes_namespace.edge, data.template_file.traefik]
  name             = "ingress"
  namespace        = kubernetes_namespace.edge.metadata.0.name
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"

  # Use a custom values.yml file
  values = [
    <<EOF
${data.template_file.traefik.rendered}
EOF
  ]
  
  set {
    name  = "ports.web.redirectTo"
    value = "websecure"
  } 
}
