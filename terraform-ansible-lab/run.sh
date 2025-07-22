#!/bin/bash
set -e

echo "🚀 Iniciando despliegue completo con Terraform + Ansible"
echo "=================================================="

cd terraform

echo "🧹 Limpiando estado anterior..."
rm -rf .terraform .terraform.lock.hcl

echo "🔧 Configurando timeouts y variables de entorno..."
export TF_PLUGIN_TIMEOUT=120s
export TF_CLI_CONFIG_FILE=""

echo "📦 Inicializando Terraform..."
terraform init

echo "🔑 Configurando permisos para plugins..."
find .terraform -name "terraform-provider-aws*" -exec chmod +x {} \;

echo "📋 Mostrando plan de ejecución..."
terraform plan

echo "✅ Aplicando infraestructura con Terraform..."
terraform apply -auto-approve

echo "⏳ Esperando que la instancia esté completamente lista..."
sleep 45

cd ..
echo "🎯 Configurando inventario de Ansible..."
IP=$(cat ip.txt)

# Crear inventario dinámico para Terraform integration
cat > ansible/hosts-ready.ini << EOF
# Inventario generado dinámicamente por run.sh
# Fecha: $(date)
# IP obtenida de Terraform: $IP

[webservers]
$IP ansible_user=ec2-user ansible_ssh_private_key_file=../demo-key.pem

[webservers:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ConnectTimeout=30'
apache_service=httpd
web_root=/var/www/html
server_role=frontend
project=terraform-ansible-lab
environment=production

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

echo "📝 Inventario creado:"
cat ansible/hosts-ready.ini

echo "🔍 Verificando conectividad SSH..."
ansible -i ansible/hosts-ready.ini webservers -m ping --timeout=30

echo "🚀 Ejecutando playbook de Ansible..."
ansible-playbook -i ansible/hosts-ready.ini ansible/playbook.yml --tags="system,webserver,verify"

echo ""
echo "✅ ¡DESPLIEGUE COMPLETADO EXITOSAMENTE!"
echo "=================================================="
echo "🌐 Sitio web principal: http://$IP"
echo "📊 Información detallada: http://$IP/info.html"
echo "📁 Backups disponibles: http://$IP/backup/"
echo ""
echo "🔧 Para administrar la infraestructura:"
echo "  - Ver estado: terraform show"
echo "  - Destruir: terraform destroy -auto-approve"
echo "  - Re-ejecutar Ansible: ansible-playbook -i ansible/hosts-ready.ini ansible/playbook.yml"
echo ""
echo "📋 Información del servidor:"
echo "  - IP Pública: $IP"
echo "  - Usuario SSH: ec2-user"
echo "  - Clave SSH: demo-key.pem"
echo "  - Puerto HTTP: 80"
echo ""