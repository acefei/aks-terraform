module "traefik" {
    source                    = "./modules/traefik"
    traefik_config            = local.traefik_config
}
