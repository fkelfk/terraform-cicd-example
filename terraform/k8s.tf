resource "kubernetes_deployment" "name" {
    metadata {
        name = "auth-deploy"
        labels = {
            "type" = "backend"
            "app" = "auth"
        }
    }
    spec {
        replicas = 3
        selector {
            match_lables = {
                "type" = "backend"
                "app" = "auth"
            }
        }
        template {
            metadata {
                name = "authpod"
                labels = {
                    "type" = "backend"
                    "app" = "auth"
                }
            }
            spec {
                container {
                    name = "auth"
                    image = var.container_image
                    port = {
                        container_port = 3310
                    }
                }
            }
        }
    }
}

resource "google_computer_address" "default" {
    name = "ipforservice"
    region = var.region
}

resource "kubernetes_serviec" "auth-service" {
    metadata {
        name = "auth-service"
    }
    spec {
        type = "loadBalancer"
        load_balancer_ip = google_computer_address.default.address
        port {
            port = 4410
            target_port = 3310
        }
        selector = {
            "type" = "backend"
            "app" = "auth"
        }
    }
}