// Log Analytics
module "log_analytics_workspace_kubernetes" {
  source                       = "../modules/log-analytics-workspace"
  resource_group_name          = module.resource_group.resource_group_name
  location                     = var.location
  log_analytics_workspace_name = "log-${module.resource_group.resource_group_location}"
  tags                         = local.common_tags
}

// AKS Cluster User-assigned managed identity
resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "id-aks"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  tags = merge(local.common_tags, {
    purpose : "AKS Identity"
  })
}

// AKS Kubelet User-assigned managed identity 
resource "azurerm_user_assigned_identity" "aks_kubelet_identity" {
  name                = "id-aks-kubelet"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  tags = merge(local.common_tags, {
    purpose : "AKS Kubelet Identity"
  })
}

// The identity AKS runs with needs to be able to assign the identity the
// kubelets are running with to nodes in the agent pools. We assign these
// permissions here through the use of the built-in 'Managed Identity Operator's role.
// AKS Kubelet Identity - AKS Identity - Managed Identity Operator Role
resource "azurerm_role_assignment" "aks_identity_managed_identity_operator_role_assignement" {
  scope                = azurerm_user_assigned_identity.aks_kubelet_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

// AKS Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                                = "aks"
  location                            = module.resource_group.resource_group_location
  resource_group_name                 = module.resource_group.resource_group_name
  dns_prefix                          = "aks"
  kubernetes_version                  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group                 = "mrg-aks-${module.resource_group.resource_group_name}"
  support_plan                        = "KubernetesOfficial"
  sku_tier                            = "Standard"
  automatic_upgrade_channel           = "rapid"
  role_based_access_control_enabled   = true
  run_command_enabled                 = true
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = true
  private_dns_zone_id                 = "None"

  azure_policy_enabled             = true
  cost_analysis_enabled            = true
  workload_identity_enabled        = true
  oidc_issuer_enabled              = true
  http_application_routing_enabled = false

  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 24

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  kubelet_identity {
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet_identity.id
    client_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_subscription.current.tenant_id
  }

  default_node_pool {
    name                    = "primary"
    vm_size                 = "Standard_DS2_v2"
    orchestrator_version    = data.azurerm_kubernetes_service_versions.current.latest_version
    zones                   = [1, 2, 3]
    auto_scaling_enabled    = true
    min_count               = 1
    max_count               = 3
    os_sku                  = "AzureLinux"
    os_disk_type            = "Managed"
    os_disk_size_gb         = 30
    host_encryption_enabled = false
    type                    = "VirtualMachineScaleSets"
    vnet_subnet_id          = azurerm_subnet.subnet_aks_nodes.id
    pod_subnet_id           = azurerm_subnet.subnet_aks_pods.id
  }

  aci_connector_linux {
    subnet_name = azurerm_subnet.subnet_aci.name
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "cilium"
    network_data_plane = "cilium"
    outbound_type      = "userAssignedNATGateway"
    ip_versions        = ["IPv4"]
    dns_service_ip     = local.aksDnsServiceIP
    service_cidr       = local.aksServiceCidr
  }

  oms_agent {
    log_analytics_workspace_id      = module.log_analytics_workspace_kubernetes.log_analytics_workspace_id
    msi_auth_for_monitoring_enabled = true
  }

  windows_profile {
    admin_username = "azureuser"
    admin_password = "Welcome2u2@@@2025"
    license        = "Windows_Server"
  }

  workload_autoscaler_profile {
    keda_enabled                    = false
    vertical_pod_autoscaler_enabled = false
  }

  tags = local.common_tags
  depends_on = [
    azurerm_subnet_nat_gateway_association.subnet_aks_nodes_nat_gateway_association,
    azurerm_subnet_nat_gateway_association.subnet_aks_pods_nat_gateway_association
  ]
}

// Linux AKS Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "linux_node_pool" {
  name                    = "nplinux"
  kubernetes_cluster_id   = azurerm_kubernetes_cluster.aks_cluster.id
  orchestrator_version    = data.azurerm_kubernetes_service_versions.current.latest_version
  mode                    = "User"
  zones                   = [1, 2, 3]
  auto_scaling_enabled    = true
  min_count               = 1
  max_count               = 3
  os_type                 = "Linux"
  os_sku                  = "AzureLinux"
  os_disk_type            = "Managed"
  os_disk_size_gb         = 30
  vm_size                 = "Standard_DS2_v2"
  host_encryption_enabled = false
  vnet_subnet_id          = azurerm_subnet.subnet_aks_nodes.id
  pod_subnet_id           = azurerm_subnet.subnet_aks_pods.id
  priority                = "Regular" # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
  node_labels = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
  }
  tags = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "linux"
  }
}

# Windows AKS Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "windows_node_pool" {
  name                    = "npwin"
  kubernetes_cluster_id   = azurerm_kubernetes_cluster.aks_cluster.id
  orchestrator_version    = data.azurerm_kubernetes_service_versions.current.latest_version
  mode                    = "User"
  zones                   = [1, 2, 3]
  auto_scaling_enabled    = true
  min_count               = 1
  max_count               = 3
  os_type                 = "Windows"
  os_sku                  = "Windows2022"
  os_disk_type            = "Managed"
  os_disk_size_gb         = 128
  vm_size                 = "Standard_DS2_v2"
  host_encryption_enabled = false
  vnet_subnet_id          = azurerm_subnet.subnet_aks_nodes.id
  pod_subnet_id           = azurerm_subnet.subnet_aks_pods.id
  priority                = "Regular"
  node_labels = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "windows"
  }
  tags = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepoolos"    = "windows"
  }
}