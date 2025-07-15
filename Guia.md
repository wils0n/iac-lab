# Laboratorio 9: Infraestructura como Código Seguro

## Capítulo 0: Instalación y Configuración del Entorno

### 0.1 Instalación de Checkov

#### Linux/Ubuntu (Bash)
```bash
# Crear carpeta temporal
mkdir -p /tmp/checkov
cd /tmp/checkov

# Para arquitectura x86_64
# Descargar checkov .zip para x86_64
  curl -L https://github.com/bridgecrewio/checkov/releases/download/3.2.445/checkov_linux_X86_64.zip -o checkov.zip

# Para arquitectura ARM64
# Descargar checkov .zip para ARM64
curl -L https://github.com/bridgecrewio/checkov/releases/download/3.2.445/checkov_linux_arm64.zip -o checkov.zip

# Descomprimir
unzip -o checkov.zip

# Dar permisos de ejecución
chmod +x dist/checkov

# Mover a /usr/local/bin
sudo mv dist/checkov /usr/local/bin/

# Limpiar carpeta temporal
cd ~
rm -rf /tmp/checkov

# Verificar instalación
checkov --version

```

#### macOS (Bash)
```bash
# Crear carpeta temporal
mkdir -p /tmp/checkov
cd /tmp/checkov

# Descargar checkov .zip para macOS x86_64
curl -L https://github.com/bridgecrewio/checkov/releases/download/3.2.445/checkov_darwin_X86_64.zip -o checkov.zip

# Descomprimir
unzip -o checkov.zip

# Dar permisos de ejecución
chmod +x checkov

# Mover a /usr/local/bin
sudo mv checkov /usr/local/bin/

# Limpiar carpeta temporal
cd ~
rm -rf /tmp/checkov

# Verificar instalación
checkov --version

```

#### Windows (PowerShell)
```powershell
# Crear directorio para checkov
$checkovDir = "C:\checkov"
New-Item -ItemType Directory -Path $checkovDir -Force | Out-Null

# Descargar archivo ZIP de Checkov
$version = "3.2.445"
$url = "https://github.com/bridgecrewio/checkov/releases/download/$version/checkov_windows_X86_64.zip"
$zipFile = "$checkovDir\checkov.zip"
Invoke-WebRequest -Uri $url -OutFile $zipFile

# Descomprimir el archivo ZIP
Expand-Archive -Path $zipFile -DestinationPath $checkovDir -Force

# Eliminar el ZIP después de descomprimir
Remove-Item $zipFile

# Agregar al PATH del usuario permanentemente si no está ya presente
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$checkovDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$checkovDir", "User")
}

# Refrescar PATH en la sesión actual
$env:PATH += ";$checkovDir"

# Verificar instalación
checkov --version
```

### 0.2 Instalación de Trivy 

#### Linux/Ubuntu (Bash)
```bash
# Método 1: Script de instalación automática
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Método 2: Descarga manual
latest=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

# Para x86_64
curl -L "https://github.com/aquasecurity/trivy/releases/download/v${latest}/trivy_${latest}_Linux-64bit.tar.gz" -o trivy.tar.gz
tar -xzf trivy.tar.gz trivy
sudo mv trivy /usr/local/bin/
rm trivy.tar.gz

# Para ARM64
curl -L "https://github.com/aquasecurity/trivy/releases/download/v${latest}/trivy_${latest}_Linux-ARM64.tar.gz" -o trivy.tar.gz
tar -xzf trivy.tar.gz trivy
sudo mv trivy /usr/local/bin/
rm trivy.tar.gz

# Verificar instalación
trivy --version
```

#### macOS (Bash)
```bash
# Descargar la última versión de Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# O descargar manualmente
latest=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -L "https://github.com/aquasecurity/trivy/releases/download/v${latest}/trivy_${latest}_macOS-64bit.tar.gz" -o trivy.tar.gz
tar -xzf trivy.tar.gz
sudo mv trivy /usr/local/bin/
rm trivy.tar.gz

# Verificar instalación
trivy --version
```

#### Windows (PowerShell)
```powershell
# Crear directorio para trivy
New-Item -ItemType Directory -Path "C:\trivy" -Force

# Obtener la última versión
$latest = (Invoke-RestMethod -Uri "https://api.github.com/repos/aquasecurity/trivy/releases/latest").tag_name
$version = $latest.TrimStart('v')

# Descargar trivy
$url = "https://github.com/aquasecurity/trivy/releases/download/$latest/trivy_${version}_Windows-64bit.zip"
Invoke-WebRequest -Uri $url -OutFile "trivy.zip"
Expand-Archive -Path "trivy.zip" -DestinationPath "C:\trivy" -Force
Remove-Item "trivy.zip"

# Agregar al PATH permanentemente
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
[Environment]::SetEnvironmentVariable("PATH", $currentPath + ";C:\trivy", "User")

# Refrescar PATH en la sesión actual
$env:PATH += ";C:\trivy"

# Verificar instalación
trivy --version
```

### 0.3 Instalación de Terrascan

#### Linux/Ubuntu (Bash)
```bash
# Obtener la última versión
latest=$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

# Para x86_64
curl -L "https://github.com/tenable/terrascan/releases/download/v${latest}/terrascan_${latest}_Linux_x86_64.tar.gz" -o terrascan.tar.gz
tar -xzf terrascan.tar.gz terrascan
sudo mv terrascan /usr/local/bin/
rm terrascan.tar.gz

# Para ARM64
curl -L "https://github.com/tenable/terrascan/releases/download/v${latest}/terrascan_${latest}_Linux_arm64.tar.gz" -o terrascan.tar.gz
tar -xzf terrascan.tar.gz terrascan
sudo mv terrascan /usr/local/bin/
rm terrascan.tar.gz

# Verificar instalación
terrascan version
```

#### macOS (Bash)
```bash
# Obtener la última versión
latest=$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

# Descargar terrascan
curl -L "https://github.com/tenable/terrascan/releases/download/v${latest}/terrascan_${latest}_Darwin_x86_64.tar.gz" -o terrascan.tar.gz

# Extraer y mover al PATH
tar -xzf terrascan.tar.gz terrascan
sudo mv terrascan /usr/local/bin/
rm terrascan.tar.gz

# Para M1/M2 Macs
curl -L "https://github.com/tenable/terrascan/releases/download/v${latest}/terrascan_${latest}_Darwin_arm64.tar.gz" -o terrascan.tar.gz
tar -xzf terrascan.tar.gz terrascan
sudo mv terrascan /usr/local/bin/
rm terrascan.tar.gz

# Verificar instalación
terrascan version
```

#### Windows (PowerShell)
```powershell
# Crear directorio para terrascan
New-Item -ItemType Directory -Path "C:\terrascan" -Force

# Obtener la última versión
$latest = (Invoke-RestMethod -Uri "https://api.github.com/repos/tenable/terrascan/releases/latest").tag_name
$version = $latest.TrimStart('v')

# Descargar terrascan
$url = "https://github.com/tenable/terrascan/releases/download/$latest/terrascan_${version}_Windows_x86_64.zip"
Invoke-WebRequest -Uri $url -OutFile "terrascan.zip"
Expand-Archive -Path "terrascan.zip" -DestinationPath "C:\terrascan" -Force
Remove-Item "terrascan.zip"

# Agregar al PATH permanentemente
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
[Environment]::SetEnvironmentVariable("PATH", $currentPath + ";C:\terrascan", "User")

# Refrescar PATH en la sesión actual
$env:PATH += ";C:\terrascan"

# Verificar instalación
terrascan version
```

### 0.4 Instalación de Terraform

#### Linux/Ubuntu (Bash)
```bash
# Crear carpeta temporal
mkdir -p /tmp/terraform
cd /tmp/terraform

# Descargar Terraform ZIP para Linux x86_64
VERSION="1.12.2"
curl -L "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip" -o terraform.zip

# Descomprimir
unzip -o terraform.zip

# Dar permisos y mover a /usr/local/bin
chmod +x terraform
sudo mv terraform /usr/local/bin/

# Limpiar
cd ~
rm -rf /tmp/terraform

# Verificar instalación
terraform -version
```

#### macOS (Bash)
```bash
# Crear carpeta temporal
mkdir -p /tmp/terraform
cd /tmp/terraform

# Descargar Terraform ZIP para macOS x86_64
VERSION="1.12.2"
curl -L "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_darwin_amd64.zip" -o terraform.zip

# Descomprimir
unzip -o terraform.zip

# Dar permisos y mover a /usr/local/bin
chmod +x terraform
sudo mv terraform /usr/local/bin/

# Limpiar
cd ~
rm -rf /tmp/terraform

# Verificar instalación
terraform -version
```

#### Windows (PowerShell)
```powershell
# Crear directorio para Terraform
$terraformDir = "C:\terraform"
New-Item -ItemType Directory -Path $terraformDir -Force | Out-Null

# Descargar Terraform zip
$version = "1.12.2"
$url = "https://releases.hashicorp.com/terraform/$version/terraform_${version}_windows_amd64.zip"
$zipFile = "$terraformDir\terraform.zip"
Invoke-WebRequest -Uri $url -OutFile $zipFile

# Descomprimir
Expand-Archive -Path $zipFile -DestinationPath $terraformDir -Force

# Eliminar el ZIP después de descomprimir
Remove-Item $zipFile

# Agregar al PATH del usuario si no está presente
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$terraformDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$terraformDir", "User")
}

# Refrescar PATH en la sesión actual
$env:PATH += ";$terraformDir"

# Verificar instalación
terraform -version
```

### Comandos de Detección de Arquitectura

Si no estás seguro de tu arquitectura, usa estos comandos:

#### Linux/macOS
```bash
# Detectar arquitectura
uname -m
# x86_64 = AMD64/Intel 64-bit
# aarch64 = ARM64
# arm64 = ARM64 (macOS)
```

#### Windows
```powershell
# Detectar arquitectura
$env:PROCESSOR_ARCHITECTURE
# AMD64 = 64-bit
# ARM64 = ARM64
```

#### Notas Importantes

- **Arquitectura**: Los comandos incluyen versiones para x86_64/AMD64 y ARM64 en todos los sistemas
- **Detección de arquitectura**: Usa `uname -m` en Linux/macOS o `$env:PROCESSOR_ARCHITECTURE` en Windows
- **PATH permanente**: En Windows, las variables se configuran permanentemente en el registro
- **Permisos**: En Linux/macOS puede requerir `sudo` para mover archivos a `/usr/local/bin/`
- **Verificación**: Siempre ejecuta los comandos de verificación para confirmar la instalación
- **Reinicio**: En Windows, puede ser necesario reiniciar la terminal para que el PATH se actualice
- **Dependencias**: No requieren gestores de paquetes, solo curl/wget y permisos de escritura

## Capítulo 1: Introducción a Terraform con Docker

### Ejercicio 1.1: Terraform Básico con Docker Provider

Crear la estructura de directorios:

#### Bash
```bash
mkdir terraform-lab
cd terraform-lab
```

#### PowerShell
```powershell
mkdir terraform-lab
cd terraform-lab
```

Crear el archivo `main.tf`:

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"
  
  ports {
    internal = 80
    external = 8000
  }
}
```

### Comandos básicos de Terraform:

#### Bash
```bash
# Inicializar Terraform
terraform init

# Ver el plan de ejecución
terraform plan

# Aplicar los cambios
terraform apply

# Verificar que el contenedor está corriendo
docker ps

# Probar la aplicación
curl http://localhost:8000

# Destruir la infraestructura
terraform destroy
```

#### PowerShell
```powershell
# Inicializar Terraform
terraform init

# Ver el plan de ejecución
terraform plan

# Aplicar los cambios
terraform apply

# Verificar que el contenedor está corriendo
docker ps

# Probar la aplicación
Invoke-WebRequest -Uri http://localhost:8000

# Destruir la infraestructura
terraform destroy
```

### Ejercicio 1.2: Variables y Outputs

Crear `variables.tf`:

```hcl
variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "my-app"
}

variable "external_port" {
  description = "External port for the application"
  type        = number
  default     = 8000
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}
```

Crear `outputs.tf`:

```hcl
output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.webapp.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.webapp.image_id
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://localhost:${var.external_port}"
}
```

Actualizar `main.tf` para usar variables:

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "webapp" {
  name         = "nginx:alpine"
  keep_locally = false
}

resource "docker_container" "webapp" {
  image = docker_image.webapp.image_id
  name  = "${var.app_name}-${var.environment}"
  
  ports {
    internal = 80
    external = var.external_port
  }
  
  labels {
    label = "environment"
    value = var.environment
  }
}
```
* Ejecutar nuevamente "terraform plan" y "terraform apply"
* Eliminar infraestructura creada con "terraform destroy"

## Capítulo 2: Ejemplos Multi-Cloud - Configuraciones Inseguras

### 2.1: Ejemplo AWS Inseguro

**Archivo `cloud-examples/aws/aws-insecure.tf`:**

```hcl
# aws-insecure.tf
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

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "mi-bucket-inseguro-ejemplo"
}

resource "aws_s3_bucket_public_access_block" "insecure_bucket_pab" {
  bucket = aws_s3_bucket.insecure_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "insecure_bucket_acl" {
  bucket = aws_s3_bucket.insecure_bucket.id
  acl    = "public-read-write"
}
```

### 2.2: Ejemplo GCP Inseguro

**Archivo `cloud-examples/gcp/gcp-insecure.tf`:**

```hcl
# gcp-insecure.tf
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

resource "google_storage_bucket" "insecure_bucket" {
  name          = "mi-bucket-inseguro-ejemplo"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = false
}

# Hacer el bucket público
resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.insecure_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "public_write" {
  bucket = google_storage_bucket.insecure_bucket.name
  role   = "roles/storage.objectCreator"
  member = "allUsers"
}
```

### 2.3: Ejemplo Azure Inseguro

**Archivo `cloud-examples/azure/azure-insecure.tf`:**

```hcl
# azure-insecure.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-storage-ejemplo"
  location = "East US"
}

resource "azurerm_storage_account" "insecure_storage" {
  name                     = "storageinseguroejemplo"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Permitir acceso HTTP
  enable_https_traffic_only = false
  
  # Sin cifrado de infraestructura
  infrastructure_encryption_enabled = false

  # Permitir acceso con clave compartida
  shared_access_key_enabled = true

  # Permitir acceso público a blobs
  allow_nested_items_to_be_public = true

  # TLS mínimo 1.0 (inseguro)
  min_tls_version = "TLS1_0"
}

resource "azurerm_storage_container" "insecure_container" {
  name                  = "contenedor-publico"
  storage_account_name  = azurerm_storage_account.insecure_storage.name
  container_access_type = "blob"
}
```

## Capítulo 3: Análisis de Seguridad

### Ejercicio 3.1: Escaneo básico con trivy

#### Bash
```bash

# Escanear configuración insegura de AWS
trivy config ./cloud-examples/aws/aws-insecure.tf

# Ver reporte detallado de AWS en JSON 
trivy config ./cloud-examples/aws/aws-insecure.tf --format json > trivy-aws-report.json

# Escanear configuración insegura de GCP
trivy config ./cloud-examples/gcp/gcp-insecure.tf

# Ver reporte detallado de GCP en JSON 
trivy config ./cloud-examples/gcp/gcp-insecure.tf --format json > trivy-gcp-report.json

# Escanear configuración insegura de Azure
trivy config ./cloud-examples/azure/azure-insecure.tf

# Ver reporte detallado de Azure en JSON 
trivy config ./cloud-examples/azure/azure-insecure.tf --format json > trivy-azure-report.json

```

#### PowerShell
```powershell

# Escanear configuración insegura de AWS
trivy config ./cloud-examples/aws/aws-insecure.tf

# Ver reporte detallado de AWS en JSON 
trivy config ./cloud-examples/aws/aws-insecure.tf --format json > trivy-aws-report.json

# Escanear configuración insegura de GCP
trivy config ./cloud-examples/gcp/gcp-insecure.tf

# Ver reporte detallado de GCP en JSON 
trivy config ./cloud-examples/gcp/gcp-insecure.tf --format json > trivy-gcp-report.json

# Escanear configuración insegura de Azure
trivy config ./cloud-examples/azure/azure-insecure.tf

# Ver reporte detallado de Azure en JSON 
trivy config ./cloud-examples/azure/azure-insecure.tf --format json > trivy-azure-report.json

```

### Ejercicio 3.2: Escaneo básico con Checkov

#### Bash
```bash
# Escanear configuración insegura de AWS
checkov -f ./cloud-examples/aws/aws-insecure.tf 

# Escanear AWS con salida JSON
checkov -f ./cloud-examples/aws/aws-insecure.tf --output json > checkov-aws-report.json

# Escanear configuración insegura de GCP
checkov -f ./cloud-examples/gcp/gcp-insecure.tf 

# Escanear GCP con salida JSON
checkov -f ./cloud-examples/gcp/gcp-insecure.tf --output json > checkov-gcp-report.json

# Escanear configuración insegura de Azure
checkov -f ./cloud-examples/azure/azure-insecure.tf 

# Escanear Azure con salida JSON
checkov -f ./cloud-examples/azure/azure-insecure.tf --output json > checkov-azure-report.json

# Escanear todo el directorio
checkov -d ./cloud-examples --framework terraform
```

#### PowerShell
```powershell
# Escanear configuración insegura de AWS
checkov -f ./cloud-examples/aws/aws-insecure.tf 

# Escanear AWS con salida JSON
checkov -f ./cloud-examples/aws/aws-insecure.tf --output json > checkov-aws-report.json

# Escanear configuración insegura de GCP
checkov -f ./cloud-examples/gcp/gcp-insecure.tf 

# Escanear GCP con salida JSON
checkov -f ./cloud-examples/gcp/gcp-insecure.tf --output json > checkov-gcp-report.json

# Escanear configuración insegura de Azure
checkov -f ./cloud-examples/azure/azure-insecure.tf 

# Escanear Azure con salida JSON
checkov -f ./cloud-examples/azure/azure-insecure.tf --output json > checkov-azure-report.json

# Escanear todo el directorio
checkov -d ./cloud-examples --framework terraform

```

### Ejercicio 3.3: Escaneo básico con terrascan

#### Bash
```bash
# Escanear configuración insegura de AWS
terrascan scan -f ./cloud-examples/aws/aws-insecure.tf

# Ver reporte AWS detallado en JSON
terrascan scan -f ./cloud-examples/aws/aws-insecure.tf  -o json > terrascan-aws-report.json

# Escanear configuración insegura de GCP
terrascan scan -f ./cloud-examples/gcp/gcp-insecure.tf

# Ver reporte GCP detallado en JSON
terrascan scan -f ./cloud-examples/gcp/gcp-insecure.tf  -o json > terrascan-gcp-report.json

# Escanear configuración insegura de Azure
terrascan scan -f ./cloud-examples/azure/azure-insecure.tf

# Ver reporte Azure detallado en JSON
terrascan scan -f ./cloud-examples/azure/azure-insecure.tf -o json > terrascan-azure-report.json
```

#### PowerShell
```powershell
# Escanear configuración insegura de AWS
terrascan scan -f ./cloud-examples/aws/aws-insecure.tf

# Ver reporte AWS detallado en JSON
terrascan scan -f ./cloud-examples/aws/aws-insecure.tf  -o json > terrascan-aws-report.json

# Escanear configuración insegura de GCP
terrascan scan -f ./cloud-examples/gcp/gcp-insecure.tf

# Ver reporte GCP detallado en JSON
terrascan scan -f ./cloud-examples/gcp/gcp-insecure.tf  -o json > terrascan-gcp-report.json

# Escanear configuración insegura de Azure
terrascan scan -f ./cloud-examples/azure/azure-insecure.tf

# Ver reporte Azure detallado en JSON
terrascan scan -f ./cloud-examples/azure/azure-insecure.tf -o json > terrascan-azure-report.json
```

## Capítulo 4: Corrección de Vulnerabilidades

### Ejercicio 4.1: Corrección AWS

#### Ejercicio 4.1.1: Implementar Correciones para archivo AWS

* Ir al directorio `./cloud-examples/aws`
* Copiar el archivo `aws-insecure.tf` como `aws-secure.tf`
* Abrir el archivo `AWS-Fixes.md` e implementar paso a paso los cambios

#### Ejercicio 4.1.2: Ejecutar checkov para determinar si los findings fueron resueltos o suprimidos

#### Bash
```bash
# Escanear configuración segura de AWS
checkov -f ./cloud-examples/aws/aws-secure.tf 

# Comparar resultado con archivo de solución 
checkov -f ./cloud-examples/aws/solucion/aws-secure.tf 
```

#### PowerShell
```powershell
# Escanear configuración segura de AWS
checkov -f ./cloud-examples/aws/aws-secure.tf 

# Comparar resultado con archivo de solución 
checkov -f ./cloud-examples/aws/solucion/aws-secure.tf 
```

### Ejercicio 4.2: Corrección GCP (Opcional)

#### Ejercicio 4.2.1: Implementar Correciones para archivo GCP

* Ir al directorio `./cloud-examples/gcp`
* Copiar el archivo `gcp-insecure.tf` como `gcp-secure.tf`
* Abrir el archivo `GCP-Fixes.md` e implementar paso a paso los cambios

#### Ejercicio 4.2.2: Ejecutar checkov para determinar si los findings fueron resueltos o suprimidos

#### Bash
```bash
# Escanear configuración segura de GCP
checkov -f ./cloud-examples/gcp/gcp-secure.tf 

# Comparar resultado con archivo de solución 
checkov -f ./cloud-examples/gcp/solucion/gcp-secure.tf 
```

#### PowerShell
```powershell
# Escanear configuración segura de GCP
checkov -f ./cloud-examples/gcp/gcp-secure.tf 

# Comparar resultado con archivo de solución 
checkov -f ./cloud-examples/gcp/solucion/gcp-secure.tf 
```

### Ejercicio 4.3: Corrección Azure (Opcional)

#### Ejercicio 4.3.1: Implementar Correciones para archivo Azure

* Ir al directorio `./cloud-examples/azure`
* Copiar el archivo `azure-insecure.tf` como `azure-secure.tf`
* Abrir el archivo `Azure-Fixes.md` e implementar paso a paso los cambios

#### Ejercicio 4.3.2: Ejecutar checkov para determinar si los findings fueron resueltos o suprimidos

#### Bash
```bash
# Escanear configuración segura de Azure
checkov -f ./cloud-examples/azure/azure-secure.tf 

# Comparar resultado con archivo de solución 
checkov -f ./cloud-examples/azure/solucion/azure-secure.tf 
```


## Ejercicio 5: Implementación de revisión de IaC en Gitlab Pipeline CI/CD

* 1. Copiar carpeta  `./cloud-examples/` a directorio de proyecto `juicy-shop-devsecops`
* 2. Reemplazar el archivo  `.gitlab-ci.yml` por el siguiente archivo: 

```yaml

# GitLab CI/CD Pipeline para escaneo de IaC
# Usa Checkov y Terrascan para análisis de seguridad

stages:
  - security-scan

variables:
  # Versiones de las herramientas
  CHECKOV_VERSION: "latest"
  TERRASCAN_VERSION: "latest"
  
  # Configuración de escaneo
  SCAN_DIRECTORY: "cloud-examples"

# Job de Checkov
checkov-scan:
  stage: security-scan
  image: 
    name: bridgecrew/checkov:${CHECKOV_VERSION}
    entrypoint: [""]
  script:
    - echo "Ejecutando Checkov en el directorio ${SCAN_DIRECTORY}"
    - checkov -d ${SCAN_DIRECTORY} --framework all --output cli --output junitxml --output-file-path . --soft-fail
  artifacts:
    when: always
    reports:
      junit: results_junitxml.xml
    paths:
      - results_junitxml.xml
    expire_in: 1 week
  only:
    - merge_requests
    - main
    - develop

# Job de Terrascan
terrascan-scan:
  stage: security-scan
  image: 
    name: tenable/terrascan:${TERRASCAN_VERSION}
    entrypoint: [""]
  script:
    - echo "Ejecutando Terrascan en el directorio ${SCAN_DIRECTORY}"
    - /go/bin/terrascan scan -i terraform -d ${SCAN_DIRECTORY} --verbose --output json > terrascan-results.json || true
    - /go/bin/terrascan scan -i terraform -d ${SCAN_DIRECTORY} --verbose
  artifacts:
    when: always
    paths:
      - terrascan-results.json
    expire_in: 1 week
  only:
    - merge_requests
    - main
    - develop
  allow_failure: true

```

* 3. Actualizar el proyecto 

```bash
  git add .gitlab-ci.yml
  git add ./cloud-examples
  git commit -a -m "Revisión IaC"
  git push
```

```powershell
  git add .gitlab-ci.yml
  git add cloud-examples
  git commit -a -m "Revisión IaC"
  git push
```

* 4. Revisar la ejecución en Gitlab "Build -> Pipeline"  