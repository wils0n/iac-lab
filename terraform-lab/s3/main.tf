terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Generar sufijo aleatorio
resource "random_id" "suffix" {
  byte_length = 4
}

# Crear bucket con nombre único
resource "aws_s3_bucket" "example" {
  bucket        = "my-tf-test-bucket-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# Configurar como sitio web estático
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.example.bucket

  index_document {
    suffix = "index.html"
  }
}

# Subir el archivo HTML
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.example.bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}

# Permitir acceso público
resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.example.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Política para permitir acceso público al sitio web
resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.example.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.example.arn}/*"
      }
    ]
  })
}

# Output de la URL del sitio web
output "website_url" {
  value = "http://${aws_s3_bucket.example.bucket}.s3-website.${var.aws_region}.amazonaws.com"
}

