terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.35.1"
    }
  }
}

provider "kubernetes" {
  host = "https://192.168.49.2:8443"

  config_path    = "~/.kube/config"
  config_context = "minikube"
}
