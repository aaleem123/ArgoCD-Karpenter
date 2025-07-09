terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "cluster" {
  name = "demo-cluster"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "demo-cluster"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_namespace" "bootcamp" {
  metadata {
    name = "bootcamp"
  }
}

resource "kubernetes_deployment" "node_app" {
  metadata {
    name      = "bootcamp-node-app"
    namespace = kubernetes_namespace.bootcamp.metadata[0].name
    labels = {
      app = "bootcamp-node"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "bootcamp-node"
      }
    }
    template {
      metadata {
        labels = {
          app = "bootcamp-node"
        }
      }
      spec {
        container {
          name  = "web"
          image = var.node_app_image
          port {
            container_port = 3000
          }
          resources {
            limits = {
              memory = "256Mi"
              cpu    = "250m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "node_app" {
  metadata {
    name      = "bootcamp-node-svc"
    namespace = kubernetes_namespace.bootcamp.metadata[0].name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"   = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
    }
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "bootcamp-node"
    }
    port {
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }
  }
}

