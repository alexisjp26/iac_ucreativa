data "azurerm_kubernetes_cluster" "k8s" {
    name = "iacdev1aks"
    resource_group_name = "iacdev1-dev-rg"
}

provider "kubernetes" {
    host                   = "${data.azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
    client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = "ucreativa04"
  }
}

resource "kubernetes_deployment" "deploy" {
  metadata {
    name = "deploy"
    namespace = kubernetes_namespace.ns.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "MyTestApp"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }


}