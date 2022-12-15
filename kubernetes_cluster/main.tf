module "vnet" {
    source                    = "./modules/vnet"

    # Passing input values to the module variables
    base_tags                 = var.base_tags
    azure_config              = var.azure_config
    vnet_config	    	      = var.vnet_config
}

module "law" {
    source                    = "./modules/law"
    count                     = local.aks_config.law_enable ? 1 : 0

    # Passing input values to the module variables
    base_tags                 = var.base_tags
    azure_config  		      = var.azure_config
    # module.aks_rg was exposed by module/aks/output.tf
    aks_rg                    = module.aks.aks_rg
}

module "sa" {
    source                    = "./modules/sa"
    count                     = local.aks_config.sa_enable ? 1 : 0

    # Passing input values to the module variables
    base_tags                 = var.base_tags
    azure_config              = var.azure_config
    # module.aks_rg was exposed by module/aks/output.tf
    aks_rg                    = module.aks.aks_rg
}

# For cost saving, only save the kube-audit diagnostic log to
# azure log analytics workspace on production and azure storage account on test/staging
module "diagnostics" {
    source                    = "./modules/diagnostics"

    # Passing input values to the module variables
    base_tags                   = var.base_tags
    azure_config                = var.azure_config
    aks_cluster_id              = module.aks.cluster_id

    # there is a count in module.sa which is tuple with 1 element
    aks_sa_id                   = local.aks_config.sa_enable ? module.sa[0].id : false

    # module.law is tuple with 1 element
    aks_law_id                  = local.aks_config.law_enable ? module.law[0].id : false
}

module "aks" {
    source                    = "./modules/aks"

    # Passing input values to the module variables
    base_tags                 = var.base_tags
    azure_config              = var.azure_config
    aks_config                = local.aks_config

    # module.vnet.id was exposed by module/vnet/output.tf
    subnet_id                 = module.vnet.id

    # module.law.id was exposed by module/law/output.tf
    log_analytics_workspace_id  = local.aks_config.law_enable ? module.law[0].id : null
}
