# Arquitectura Ansible Multi-Grupo

## 🏗️ Arquitectura del Sistema

```
                        +-----------------------+
                        | Ansible Management    |
                        |        Node           |
                        +----------+------------+
                                   |
                   +---------------+-----------------+
                   |                                 |
             +-----v-----+                     +-----v-----+
             | Playbook  |                     | Inventory |
             +-----------+                     +-----------+
                  |                                  |
                  |                                  v
                  |                        ┌─────────────────┐
                  |                        │  GRUPO A        │
                  |                        │  [webservers]   │
                  |                        │  • web1         │
                  |                        │  • web2         │
                  |                        │  • web3         │
                  |                        └─────────────────┘
                  |                                  |
                  |                        ┌─────────────────┐
                  |                        │  GRUPO B        │
                  |                        │  [dbservers]    │
                  |                        │  • db1          │
                  |                        │  • db2          │
                  |                        └─────────────────┘
                  |                                  |
                  |                        ┌─────────────────┐
                  |                        │  GRUPO C        │
                  |                        │ [loadbalancers] │
                  |                        │  • lb1          │
                  |                        │  • lb2          │
                  |                        └─────────────────┘
                  |                                  |
                  +----------------------------------+
                                   |
                    +--------------+--------------+
                    |              |              |
                 SSH             SSH            SSH
                    |              |              |
               +----v----+     +----v----+     +----v----+
               | Host 1  |     | Host 2  |     | Host N  |
               |(grupo A)|     |(grupo B)|     |(grupo C)|
               +---------+     +---------+     +---------+
```

## 📁 Estructura de Archivos

```
ansible/
├── inventory.ini              # Inventario principal multi-grupo
├── hosts-ready.ini           # Inventario dinámico generado por Terraform
├── playbook.yml              # Playbook principal actualizado
├── templates/                # Templates Jinja2
│   ├── index.html.j2        # Página web personalizada
│   ├── info.html.j2         # Página de información del sistema
│   ├── httpd.conf.j2        # Configuración de Apache
│   └── nginx.conf.j2        # Configuración de Nginx Load Balancer
└── group_vars/               # Variables por grupos (opcional)
    ├── webservers.yml
    ├── dbservers.yml
    └── loadbalancers.yml
```

## 🎯 Grupos de Servidores

### GRUPO A: Servidores Web ([webservers])

**Función:** Frontend, servidores de aplicación

- **Servicios:** Apache HTTP, Nginx
- **Puertos:** 80 (HTTP), 443 (HTTPS)
- **Variables específicas:**
  - `apache_service=httpd`
  - `web_root=/var/www/html`
  - `server_role=frontend`

### GRUPO B: Servidores de Base de Datos ([dbservers])

**Función:** Backend, almacenamiento de datos

- **Servicios:** MariaDB, MySQL, PostgreSQL
- **Puertos:** 3306 (MySQL), 5432 (PostgreSQL)
- **Variables específicas:**
  - `mysql_port=3306`
  - `server_role=database`

### GRUPO C: Balanceadores de Carga ([loadbalancers])

**Función:** Distribución de tráfico, alta disponibilidad

- **Servicios:** Nginx, HAProxy
- **Puertos:** 80 (HTTP), 443 (HTTPS)
- **Variables específicas:**
  - `nginx_port=80`
  - `backend_servers=web1,web2,web3`
  - `server_role=loadbalancer`

## 🔧 Playbook Mejorado

### Nuevas Características:

1. **📦 Actualización del sistema** - Mantiene servidores actualizados
2. **🔥 Configuración de firewall** - Seguridad de puertos
3. **📄 Templates dinámicos** - Configuraciones personalizadas
4. **🔍 Verificaciones automáticas** - Health checks
5. **📊 Información detallada** - Página de información del sistema
6. **🏷️ Tags organizados** - Ejecución selectiva de tareas
7. **🔄 Handlers inteligentes** - Reinicio de servicios cuando sea necesario

### Comandos de Ejecución:

#### Ejecutar todo el playbook:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

#### Ejecutar solo tareas específicas:

```bash
# Solo actualizaciones del sistema
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags="system"

# Solo configuración web
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags="webserver"

# Solo verificaciones
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags="verify"
```

#### Ejecutar en grupos específicos:

```bash
# Solo servidores web
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --limit="webservers"

# Solo bases de datos
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --limit="dbservers"

# Solo balanceadores
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --limit="loadbalancers"
```

## 🌐 Variables por Grupo

### Variables Globales ([all:vars])

```yaml
ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
ansible_python_interpreter: /usr/bin/python3
environment: production
project: terraform-ansible-lab
```

### Variables de Webservers ([webservers:vars])

```yaml
apache_service: httpd
web_root: /var/www/html
server_role: frontend
```

### Variables de DB Servers ([dbservers:vars])

```yaml
mysql_root_password: SecurePass123!
mysql_port: 3306
server_role: database
```

### Variables de Load Balancers ([loadbalancers:vars])

```yaml
nginx_port: 80
backend_servers: web1.example.com,web2.example.com
server_role: loadbalancer
```

## 🎭 Meta-Grupos (Grupos de Grupos)

### [production:children]

Agrupa todos los servidores de producción:

- webservers
- dbservers
- loadbalancers

### [frontend:children]

Servidores que manejan tráfico público:

- webservers
- loadbalancers

### [backend:children]

Servidores internos:

- dbservers

## 🚀 Ejecución con run.sh

El script actualizado ahora:

1. 🧹 **Limpia** el estado anterior
2. 🔧 **Configura** timeouts y variables
3. 📦 **Inicializa** Terraform
4. 🔑 **Configura** permisos de plugins
5. 📋 **Muestra** el plan de ejecución
6. ✅ **Aplica** la infraestructura
7. ⏳ **Espera** que la instancia esté lista
8. 🎯 **Genera** inventario dinámico
9. 🔍 **Verifica** conectividad SSH
10. 🚀 **Ejecuta** el playbook de Ansible
11. 📊 **Muestra** información de resultado

## 📋 Comandos Útiles

### Verificar conectividad:

```bash
ansible -i ansible/hosts-ready.ini all -m ping
```

### Obtener información del sistema:

```bash
ansible -i ansible/hosts-ready.ini all -m setup
```

### Ejecutar comandos ad-hoc:

```bash
ansible -i ansible/hosts-ready.ini webservers -m shell -a "systemctl status httpd"
```

### Ver información de grupos:

```bash
ansible-inventory -i ansible/inventory.ini --list
```

## 🔐 Seguridad

- ✅ **SSH Keys** - Autenticación sin contraseñas
- ✅ **StrictHostKeyChecking** - Deshabilitado para lab
- ✅ **Firewall** - Configurado automáticamente
- ✅ **Service Users** - Servicios con usuarios específicos
- ✅ **File Permissions** - Permisos adecuados para archivos web

## 🎯 Beneficios de esta Arquitectura

1. **🏗️ Escalabilidad** - Fácil agregar nuevos hosts
2. **🎛️ Flexibilidad** - Configuraciones específicas por grupo
3. **🔧 Mantenibilidad** - Código organizado y reutilizable
4. **🚀 Automatización** - Script completo de despliegue
5. **📊 Visibilidad** - Información detallada del sistema
6. **🔍 Debugging** - Tags y límites para ejecución selectiva

¡Esta arquitectura te permite gestionar infraestructuras complejas de manera eficiente y organizada! 🎉
