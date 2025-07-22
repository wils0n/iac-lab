# Infrastructure as Code (IaC) - Laboratorios de Seguridad

Este repositorio contiene una colección completa de laboratorios y ejemplos prácticos para aprender **Infrastructure as Code** con enfoque en seguridad y mejores prácticas.

## 🎯 Objetivos del Repositorio

- Aprender Terraform con Docker y proveedores cloud
- Implementar configuraciones seguras en AWS, Azure y GCP
- Analizar y remediar vulnerabilidades en código IaC
- Integrar análisis de seguridad en pipelines CI/CD
- Provisionar infraestructura con CloudFormation y Terraform/Ansible

## 📁 Estructura del Proyecto

```
├── aws-cloudformation-rekognition/    # Lab de reconocimiento de imágenes con AWS
├── cloud-examples/                    # Ejemplos multi-cloud con análisis de seguridad
│   ├── aws/                          # Configuraciones AWS (inseguras y seguras)
│   │   ├── aws-insecure.tf          # Configuración insegura para análisis
│   │   ├── AWS-Fixes.md             # Guía de correcciones de seguridad
│   │   └── solucion/                # Configuración segura
│   ├── azure/                        # Configuraciones Azure (inseguras y seguras)
│   │   ├── azure-insecure.tf        # Configuración insegura para análisis
│   │   ├── Azure-Fixes.md           # Guía de correcciones de seguridad
│   │   └── solucion/                # Configuración segura
│   └── gcp/                          # Configuraciones GCP (inseguras y seguras)
│       ├── gcp-insecure.tf          # Configuración insegura para análisis
│       ├── GCP-Fixes.md             # Guía de correcciones de seguridad
│       └── solucion/                # Configuración segura
├── docs/                             # Guías y documentación
│   ├── guía-awscloudformation.md    # Tutorial CloudFormation + Rekognition
│   ├── guía-devsecops.md            # Lab completo de DevSecOps
│   └── guía-análisis-seguridad.md   # Análisis con herramientas de seguridad
├── terraform-ansible-lab/           # Lab combinado Terraform + Ansible
│   ├── terraform/                   # Configuraciones Terraform
│   ├── ansible/                     # Playbooks Ansible
│   ├── run.sh                       # Script de automatización
│   └── demo-key.pem                 # Clave SSH para EC2
└── terraform-lab/                   # Labs básicos de Terraform
    ├── s3/                          # Terraform con S3
    └── terraform-nginx-html/        # Terraform con Docker/Nginx
```

## 🚀 Laboratorios Disponibles

### 1. CloudFormation + Amazon Rekognition

**Directorio:** `aws-cloudformation-rekognition/`

Provisiona una API completa de reconocimiento de imágenes utilizando:

- **AWS Lambda** - Función serverless para procesamiento
- **Amazon Rekognition** - Servicio de análisis de imágenes con IA
- **API Gateway** - API REST para exponer la funcionalidad
- **IAM Roles y Políticas** - Permisos y seguridad

**Ejecución:**

```bash
cd aws-cloudformation-rekognition/
# Sigue las instrucciones en docs/guía-awscloudformation.md
```

### 2. Terraform + Ansible (EC2 + Web Server)

**Directorio:** `terraform-ansible-lab/`

Combina Terraform para provisionar infraestructura y Ansible para configuración:

- **Terraform:** Crea instancias EC2 con Security Groups
- **Ansible:** Configura servidores web automáticamente
- **Automatización:** Script completo de despliegue

**Ejecución rápida:**

```bash
cd terraform-ansible-lab/
./run.sh
# Accede a http://IP-GENERADA
```

### 3. Análisis de Seguridad Multi-Cloud

**Directorio:** `cloud-examples/`

Ejemplos de configuraciones **intencionalmente inseguras** y sus correcciones:

#### AWS (S3, IAM, EC2)

- ❌ **Inseguro:** Buckets S3 públicos, políticas IAM permisivas
- ✅ **Seguro:** Cifrado, acceso restringido, principio de menor privilegio

#### Azure (Storage, Network)

- ❌ **Inseguro:** Storage Accounts sin cifrado, acceso HTTP
- ✅ **Seguro:** HTTPS obligatorio, cifrado de infraestructura

#### GCP (Cloud Storage, IAM, Compute)

- ❌ **Inseguro:** Buckets públicos, acceso sin restricciones
- ✅ **Seguro:** Uniform bucket-level access, IAM restrictivo

**Herramientas de análisis:**

```bash
# Checkov
checkov -f cloud-examples/aws/aws-insecure.tf

# Trivy
trivy config cloud-examples/aws/aws-insecure.tf

# Terrascan
terrascan scan -f cloud-examples/aws/aws-insecure.tf
```

### 4. Terraform con Docker y S3

**Directorio:** `terraform-lab/`

Laboratorios introductorios:

- **Docker Provider:** Nginx con contenido personalizado
- **AWS S3:** Hosting estático de sitios web
- **Variables y Outputs:** Configuración dinámica

## 🛠️ Prerrequisitos

### Herramientas Básicas

- **Terraform** (v1.12+)
- **Docker Desktop**
- **AWS CLI** (configurado con credenciales)
- **Ansible** (para labs específicos)

### Herramientas de Análisis de Seguridad

- **Checkov** - Análisis estático de políticas de seguridad
- **Trivy** - Scanner de vulnerabilidades en IaC
- **Terrascan** - Análisis de configuraciones inseguras

### Instalación Rápida

#### macOS

```bash
# Terraform
brew install terraform

# Docker
brew install --cask docker

# AWS CLI
brew install awscli

# Herramientas de seguridad
brew install checkov trivy terrascan
```

#### Linux (Ubuntu/Debian)

```bash
# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# AWS CLI
sudo apt install awscli
```

## 📚 Guías Disponibles

| Guía                                                          | Descripción                                    | Nivel      |
| ------------------------------------------------------------- | ---------------------------------------------- | ---------- |
| [guía-awscloudformation.md](docs/guía-awscloudformation.md)   | Tutorial completo CloudFormation + Rekognition | Intermedio |
| [guía-devsecops.md](docs/guía-devsecops.md)                   | Laboratorio DevSecOps con pipelines CI/CD      | Avanzado   |
| [guía-análisis-seguridad.md](docs/guía-análisis-seguridad.md) | Análisis con Checkov, Trivy y Terrascan        | Intermedio |

## 🔒 Aspectos de Seguridad

### Configuraciones Analizadas

- **S3 Bucket Policies** - Prevención de acceso público no deseado
- **IAM Roles y Políticas** - Principio de menor privilegio
- **Security Groups** - Restricción de puertos y protocolos
- **Cifrado** - En tránsito y en reposo
- **Logging y Monitoreo** - CloudTrail, CloudWatch

### Vulnerabilidades Comunes

- Buckets S3 públicos sin intención
- Políticas IAM demasiado permisivas
- Credenciales hardcodeadas en código
- Puertos abiertos innecesariamente
- Ausencia de cifrado

## 🚦 Guía de Inicio Rápido

### 1. Configurar AWS

```bash
aws configure
# Ingresa Access Key, Secret Key, y región (us-east-1)
```

### 2. Ejecutar Análisis de Seguridad

```bash
cd cloud-examples/aws/
checkov -f aws-insecure.tf
```

### 3. Provisionar Infraestructura

```bash
cd terraform-ansible-lab/
./run.sh
```

### 4. Limpiar Recursos

```bash
cd terraform-ansible-lab/terraform/
terraform destroy -auto-approve
```

## 🎓 Flujo de Aprendizaje Recomendado

1. **Inicio:** `terraform-lab/` - Conceptos básicos de Terraform
2. **Práctica:** `terraform-ansible-lab/` - Combinación de herramientas
3. **Seguridad:** `cloud-examples/` - Análisis y corrección de vulnerabilidades
4. **AWS Avanzado:** `aws-cloudformation-rekognition/` - Servicios serverless
5. **DevSecOps:** Seguir `docs/guía-devsecops.md` - Pipeline completo

## 🤝 Contribuciones

¿Encontraste un bug o quieres agregar un ejemplo?

1. Haz fork del repositorio
2. Crea una branch: `git checkout -b feature/nueva-funcionalidad`
3. Commit: `git commit -am 'Agregar nueva funcionalidad'`
4. Push: `git push origin feature/nueva-funcionalidad`
5. Crea un Pull Request

## 📜 Licencia

Este proyecto está licenciado bajo MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## ⚠️ Advertencia

Los archivos marcados como "insecure" contienen **configuraciones intencionalmente vulnerables** para fines educativos. **NO** los uses en entornos de producción.

---

**🎯 ¡Mantén tu infraestructura segura con IaC!**
