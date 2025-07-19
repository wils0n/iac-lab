# azure-secure.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = "rg-storage-ejemplo"
  location = "East US"
  
  tags = {
    environment = "production"
    security    = "high"
  }
}

# User Assigned Identity para CMK
resource "azurerm_user_assigned_identity" "storage_identity" {
  name                = "storage-identity"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Key Vault para Customer Managed Keys
resource "azurerm_key_vault" "storage_kv" {
  name                       = "kv-storage-ejemplo"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 90

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create", "Get", "List", "Delete", "Purge", "Update", "Recover"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.storage_identity.principal_id

    key_permissions = [
      "Get", "UnwrapKey", "WrapKey"
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = [] # Agregar IPs permitidas
  }
}

# Key para cifrado
resource "azurerm_key_vault_key" "storage_key" {
  name         = "storage-encryption-key"
  key_vault_id = azurerm_key_vault.storage_kv.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

# Virtual Network para Private Endpoints
resource "azurerm_virtual_network" "secure_vnet" {
  name                = "vnet-secure"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "storage_subnet" {
  name                 = "subnet-storage"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.secure_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  
  service_endpoints = ["Microsoft.Storage"]
}

# Log Analytics Workspace para auditoría
resource "azurerm_log_analytics_workspace" "storage_logs" {
  name                = "law-storage-ejemplo"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 90
}

# Storage Account con configuración segura
resource "azurerm_storage_account" "secure_storage" {
  name                     = "storageseguroejemplo"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS" # Geo-redundant storage

  # Solo tráfico HTTPS
  enable_https_traffic_only = true
  
  # Cifrado de infraestructura habilitado
  infrastructure_encryption_enabled = true

  # Deshabilitar acceso con clave compartida (usar Azure AD)
  shared_access_key_enabled = false

  # Deshabilitar acceso público
  allow_nested_items_to_be_public = false

  # TLS 1.2 mínimo
  min_tls_version = "TLS1_2"

  # Identidad del sistema
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.storage_identity.id]
  }

  # Customer Managed Key
  customer_managed_key {
    key_vault_key_id          = azurerm_key_vault_key.storage_key.id
    user_assigned_identity_id = azurerm_user_assigned_identity.storage_identity.id
  }

  # Configuración de red restrictiva
  network_rules {
    default_action             = "Deny"
    ip_rules                   = [] # Agregar IPs permitidas
    virtual_network_subnet_ids = [azurerm_subnet.storage_subnet.id]
    bypass                     = ["AzureServices", "Logging", "Metrics"]
  }

  # Configuración de blob properties
  blob_properties {
    versioning_enabled = true
    
    delete_retention_policy {
      days = 30
    }
    
    container_delete_retention_policy {
      days = 30
    }
    
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD"]
      allowed_origins    = ["https://trusted-domain.com"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }

    # Inmutabilidad para cumplimiento
    restore_policy {
      days = 29
    }
  }

  # Defender for Storage
  azure_files_authentication {
    directory_type = "AADDS"
  }

  tags = {
    environment = "production"
    compliance  = "enabled"
    security    = "high"
  }
}

# Container privado
resource "azurerm_storage_container" "secure_container" {
  name                  = "contenedor-privado"
  storage_account_name  = azurerm_storage_account.secure_storage.name
  container_access_type = "private"
}

# Private Endpoint para acceso seguro
resource "azurerm_private_endpoint" "storage_pe" {
  name                = "pe-storage"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.storage_subnet.id

  private_service_connection {
    name                           = "psc-storage"
    private_connection_resource_id = azurerm_storage_account.secure_storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

# Monitor diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "storage_diagnostics" {
  name               = "storage-diagnostics"
  target_resource_id = azurerm_storage_account.secure_storage.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.storage_logs.id

  metric {
    category = "Transaction"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "StorageRead"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "StorageWrite"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "StorageDelete"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }
}

# Alert para acceso no autorizado
resource "azurerm_monitor_metric_alert" "unauthorized_access" {
  name                = "alert-unauthorized-access"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_storage_account.secure_storage.id]
  description         = "Alert when unauthorized access is attempted"

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Transactions"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 5

    dimension {
      name     = "ResponseType"
      operator = "Include"
      values   = ["AuthorizationError"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.security_team.id
  }
}

# Action Group para alertas
resource "azurerm_monitor_action_group" "security_team" {
  name                = "ag-security-team"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "security"

  email_receiver {
    name          = "security-team"
    email_address = "security@example.com"
  }
}

# Data source para configuración actual
data "azurerm_client_config" "current" {}