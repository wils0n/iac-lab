#!/bin/bash
cd terraform

echo "🧹 Limpiando estado anterior..."
rm -rf .terraform .terraform.lock.hcl

echo "🔧 Configurando timeouts..."
export TF_PLUGIN_TIMEOUT=120s

echo "📦 Inicializando Terraform..."
terraform init

echo "🔑 Dando permisos a plugins..."
find .terraform -name "terraform-provider-aws*" -exec chmod +x {} \;

echo "✅ Aplicando configuración..."
terraform apply -auto-approve

cd ..
echo "🎯 Configurando Ansible..."
IP=$(cat ip.txt)
sed "s/{{ public_ip }}/$IP/" ansible/hosts.ini > ansible/hosts-ready.ini

echo "🚀 Ejecutando Ansible..."
ansible-playbook -i ansible/hosts-ready.ini ansible/playbook.yml

echo "✅ Abre en tu navegador: http://$IP"