terraform {
  backend "pg" {}
  required_version = ">= 0.13"

  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "kube_config.yml"
  }
}

provider "kubectl" {
  config_path = "kube_config.yml"
}

provider "kubernetes" {
  config_path = "kube_config.yml"
}

data "local_file" "efs_name" {
  filename = "efs_name"
}

resource "helm_release" "ingress-nginx" {
  name = "ingress-nginx"
  namespace = "ingress-nginx"
  create_namespace = true
  version = "3.12.0"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
}

resource "helm_release" "eks_efs_csi_driver" {
  chart      = "aws-efs-csi-driver"
  name       = "efs"
  namespace  = "storage"
  create_namespace = true
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${var.region}.amazonaws.com/eks/aws-efs-csi-driver"
  }
}

resource "kubernetes_storage_class" "storage_class" {
  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    directoryPerms   = "700"
    fileSystemId     = trimspace(data.local_file.efs_name.content)
    provisioningMode = "efs-ap"
  }
  reclaim_policy = "Retain"
  metadata {
    name = "efs-sc"
  }
}

resource "helm_release" "cert_manager" {
  name = "cert-manager"
  namespace = "cert-manager"
  create_namespace = true
  version = "1.1.0"
  repository = "https://charts.jetstack.io"
  chart = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubectl_manifest" "prod_issuer" {
  depends_on = [helm_release.cert_manager]
  yaml_body = file("./k8s/prod_issuer.yaml")
}

resource "kubectl_manifest" "staging_issuer" {
  depends_on = [helm_release.cert_manager]
  yaml_body = file("./k8s/staging_issuer.yaml")
}

resource "helm_release" "fcrepo" {
  name = "fcrepo"
  namespace = "default"
  create_namespace = true
  repository = "https://samvera-labs.github.io/fcrepo-charts"
  chart = "fcrepo"
  values = [
    file("k8s/fcrepo-values.yaml")
  ]

}

resource "helm_release" "solr" {
  name = "solr"
  namespace = "default"
  create_namespace = true
  repository = "https://charts.bitnami.com/bitnami"
  chart = "solr"
  values = [
    file("k8s/solr-values.yaml")
  ]
}

resource "helm_release" "keel" {
  name = "keel"
  namespace = "keel"
  repository = "https://charts.keel.sh"
  chart = "keel"
  create_namespace = true
  version = "0.9.5"

  set {
    name = "debug"
    value = "true"
  }

  set {
    name = "service.enabled"
    value = "true"
  }

  set {
    name = "helmProvider.enabled"
    value = "false"
  }

  set {
    name = "basicauth.enabled"
    value = "true"
  }

  set {
    name = "basicauth.user"
    value = "admin"
  }

  set {
    name = "basicauth.password"
    value = var.keel_password
  }

  set {
    name = "image.tag"
    value = "latest"
  }
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
    annotations      = {
      "cattle.io/status"                          = jsonencode(
        {
          Conditions = [
            {
              LastUpdateTime = "2021-07-28T05:25:40Z"
              Message        = ""
              Status         = "True"
              Type           = "ResourceQuotaInit"
            },
            {
              LastUpdateTime = "2021-07-28T05:25:41Z"
              Message        = ""
              Status         = "True"
              Type           = "InitialRolesPopulated"
            },
          ]
        })
      "field.cattle.io/projectId" = "c-d2h56:p-pdrrv"
      "lifecycle.cattle.io/create.namespace-auth" = "true"
    }
    labels = {
      "field.cattle.io/projectId" = "p-pdrrv"
    }
  }
}

resource "kubernetes_namespace" "productionn" {
  metadata {
    name = "production"
    annotations = {
      "cattle.io/status"                          = jsonencode(
        {
          Conditions = [
            {
              LastUpdateTime = "2021-07-28T05:25:40Z"
              Message        = ""
              Status         = "True"
              Type           = "ResourceQuotaInit"
            },
            {
              LastUpdateTime = "2021-07-28T05:25:41Z"
              Message        = ""
              Status         = "True"
              Type           = "InitialRolesPopulated"
            },
          ]
        }
        )
      "field.cattle.io/projectId"                 = "c-d2h56:p-pdrrv"
      "lifecycle.cattle.io/create.namespace-auth" = "true"
    }
    labels           = {
      "field.cattle.io/projectId" = "p-pdrrv"
    }
  }
}

resource "kubectl_manifest" "gitlab-secrets" {
  depends_on = [helm_release.cert_manager]
  yaml_body = file("k8s/gitlab-secret-values.yaml")
}

# Zalando
# v 1.8 is max version until we go to k8s 1.25+
resource "helm_release" "zalando-postgres-operator" {
  name = "zalando-postgres-operator"
  create_namespace = true
  namespace = "zalando-postgres-operator"
  version = "1.8.2"
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
  chart = "postgres-operator"
  values = [
    templatefile("k8s/zalando-postgres-operator-values.yaml", {
      backup_bucket = var.pg_bucket
      region = var.region
      aws_access_key_id = var.aws_access_key_id
      aws_secret_access_key = var.aws_secret_access_key
    })
  ]
}

resource "helm_release" "zalando-postgres-operator-ui" {
  depends_on = [helm_release.zalando-postgres-operator]
  name = "zalando-postgres-operator-ui"
  create_namespace = true
  namespace = "zalando-postgres-operator"
  version = "1.8.2"
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator-ui"
  chart = "postgres-operator-ui"
  values = [
    templatefile("k8s/zalando-postgres-operator-ui-values.yaml", {
      backup_bucket = var.pg_bucket
      region = var.region
      aws_access_key_id = var.aws_access_key_id
      aws_secret_access_key = var.aws_secret_access_key
    })
  ]
}

resource "kubectl_manifest" "postgres-cluster-alpha" {
  depends_on = [helm_release.zalando-postgres-operator-ui]
  yaml_body =     templatefile("k8s/postgres-cluster-alpha-values.yaml", {
    databases = split(",", var.pg_alpha_databases)
  })
}
