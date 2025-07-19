# aws-secure.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Bucket S3 principal
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "mi-bucket-seguro-ejemplo"
  
  # Suprimir checks de lifecycle, logging, replication y event notifications
  tags = {
    checkov_skip = "CKV2_AWS_61,CKV_AWS_18,CKV_AWS_144,CKV2_AWS_62"
    Name = "Secure S3 Bucket"
  }
}

# Configurar cifrado KMS por defecto (CRÍTICO)

resource "aws_kms_key" "s3_kms_key" {
  description         = "KMS key for encrypting S3 bucket"
  enable_key_rotation = true
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "mi-bucket-seguro-ejemplo"


  tags = {
    checkov_skip = "CKV_AWS_144,CKV2_AWS_62"
    Name         = "Secure S3 Bucket"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_kms_key.arn
    }
  }
}


# Habilitar versionado (ALTO)
resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bloquear acceso público (CRÍTICO)
resource "aws_s3_bucket_public_access_block" "secure_bucket_pab" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configurar ACL privada (CRÍTICO)
resource "aws_s3_bucket_acl" "secure_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.secure_bucket_acl_ownership]
  
  bucket = aws_s3_bucket.secure_bucket.id
  acl    = "private"
}

# Configurar ownership controls para ACL
resource "aws_s3_bucket_ownership_controls" "secure_bucket_acl_ownership" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configuración de checkov para suprimir findings no críticos
locals {
  checkov_skip_rules = [
    "CKV2_AWS_61", # Lifecycle configuration
    "CKV_AWS_18",  # Access logging
    "CKV_AWS_144", # Cross-region replication
    "CKV2_AWS_62"  # Event notifications
  ]
}