# gcp-secure.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "mi-proyecto-ejemplo"
  region  = "us-central1"
}

# Bucket para logs de auditoría
resource "google_storage_bucket" "log_bucket" {
  name          = "mi-bucket-logs-ejemplo"
  location      = "US"
  force_destroy = false

  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }

  versioning {
    enabled = true
  }
}

# KMS Key Ring
resource "google_kms_key_ring" "bucket_keyring" {
  name     = "bucket-keyring"
  location = "us-central1"
}

# KMS Crypto Key
resource "google_kms_crypto_key" "bucket_key" {
  name            = "bucket-crypto-key"
  key_ring        = google_kms_key_ring.bucket_keyring.id
  rotation_period = "7776000s" # 90 días

  lifecycle {
    prevent_destroy = true
  }
}

# Bucket principal con configuración segura
resource "google_storage_bucket" "secure_bucket" {
  name          = "mi-bucket-seguro-ejemplo"
  location      = "US"
  force_destroy = false

  # Habilitar Uniform Bucket Level Access (solo IAM)
  uniform_bucket_level_access = true

  # Cifrado con Customer-Managed Key
  encryption {
    default_kms_key_name = google_kms_crypto_key.bucket_key.id
  }

  # Versionado habilitado
  versioning {
    enabled = true
  }

  # Logging habilitado
  logging {
    log_bucket        = google_storage_bucket.log_bucket.name
    log_object_prefix = "bucket-logs/"
  }

  # Lifecycle rules
  lifecycle_rule {
    condition {
      age = 30
      matches_storage_class = ["NEARLINE"]
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365
      matches_storage_class = ["COLDLINE"]
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }

  # Configuración CORS restrictiva (si es necesaria)
  cors {
    origin          = ["https://trusted-domain.com"]
    method          = ["GET", "HEAD"]
    response_header = ["Content-Type"]
    max_age_seconds = 3600
  }

  # Retención de datos (opcional, según requerimientos)
  retention_policy {
    retention_period = 2592000 # 30 días
    is_locked        = false
  }

  labels = {
    environment = "production"
    security    = "high"
    compliance  = "enabled"
  }
}

# IAM con acceso restrictivo - Solo usuarios/grupos específicos
resource "google_storage_bucket_iam_member" "restricted_viewer" {
  bucket = google_storage_bucket.secure_bucket.name
  role   = "roles/storage.objectViewer"
  member = "group:authorized-viewers@example.com"
}

resource "google_storage_bucket_iam_member" "restricted_admin" {
  bucket = google_storage_bucket.secure_bucket.name
  role   = "roles/storage.admin"
  member = "group:storage-admins@example.com"
}

# Política de organización para prevenir acceso público (opcional)
resource "google_project_organization_policy" "prevent_public_access" {
  project    = "mi-proyecto-ejemplo"
  constraint = "storage.publicAccessPrevention"

  boolean_policy {
    enforced = true
  }
}

# Alertas de seguridad (opcional)
resource "google_monitoring_alert_policy" "bucket_public_access_alert" {
  display_name = "Bucket Public Access Alert"
  combiner     = "OR"

  conditions {
    display_name = "Bucket made public"
    condition_threshold {
      filter          = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\" AND protoPayload.request.policy.bindings.members=\"allUsers\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
    }
  }

  notification_channels = [] # Agregar canales de notificación según necesidad

  alert_strategy {
    auto_close = "604800s" # 7 días
  }
}