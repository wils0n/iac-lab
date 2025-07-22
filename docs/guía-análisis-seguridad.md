# Laboratorio: Análisis de seguridad de la Infraestructura como Código

## Capítulo 1: Instalación y Configuración del Entorno

### 1.1 Instalación de Checkov

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

### 1.2 Instalación de Trivy

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

### 1.3 Instalación de Terrascan

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

## Capítulo 2: Análisis de Seguridad

### Ejercicio 2.1: Escaneo básico con trivy

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
# Escanear configuración aws-cloudformation
trivy config ./aws-cloudformation-rekognition/rekognition-template.yml

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

### Ejercicio 2.2: Escaneo básico con Checkov

#### Bash

```bash
# Escanear configuración aws-cloudformation
checkov -f ./aws-cloudformation-rekognition/rekognition-template.yml

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

### Ejercicio 2.3: Escaneo básico con terrascan

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
