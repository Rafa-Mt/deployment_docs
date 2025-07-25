# Apache

Apache es uno de los servidores web más populares y ampliamente utilizados. Es conocido por su flexibilidad y capacidad para manejar una amplia variedad de configuraciones.

## Importancia

- Es altamente configurable y extensible mediante módulos.
- Compatible con una amplia gama de sistemas operativos.
- Ideal para aplicaciones que requieren configuraciones avanzadas o personalizadas.

## Instalación

En sistemas basados en Debian/Ubuntu:

```bash
sudo apt update
sudo apt install apache2
```

## Configuración básica

El archivo principal de configuración se encuentra en `/etc/apache2/apache2.conf`. Para configurar un sitio web, edita o crea un archivo en `/etc/apache2/sites-available/`.

Ejemplo de configuración para un sitio:

```apache
<VirtualHost *:80>
    ServerName decoupled.com
    DocumentRoot /var/www/decoupled
    <Directory /var/www/decoupled>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

Habilita el sitio y reinicia Apache:

```bash
sudo a2ensite decoupled.conf
sudo systemctl restart apache2
```

## Configuración como Proxy Inverso

Si Apache está configurado como proxy inverso para un servicio que ya está corriendo en un puerto específico (por ejemplo, un frontend servido por PM2 en el puerto 3000), puedes configurar Apache para redirigir las solicitudes a ese puerto.

Ejemplo de configuración:

```apache
<VirtualHost *:80>
    ServerName decoupled.com

    ProxyPreserveHost On
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/

    ErrorLog ${APACHE_LOG_DIR}/decoupled-error.log
    CustomLog ${APACHE_LOG_DIR}/decoupled-access.log combined
</VirtualHost>
```

### Pasos para habilitar esta configuración:

1. Habilita los módulos necesarios:

   ```bash
   sudo a2enmod proxy
   sudo a2enmod proxy_http
   ```

2. Crea o edita el archivo de configuración del sitio en `/etc/apache2/sites-available/decoupled.conf` con el contenido anterior.

3. Habilita el sitio y reinicia Apache:

   ```bash
   sudo a2ensite decoupled.conf
   sudo systemctl restart apache2
   ```

## Configuración para Archivos Estáticos

Si deseas servir archivos estáticos (por ejemplo, un bundle generado por una herramienta como Vite), puedes configurar Apache para que apunte al directorio donde se encuentran los archivos.

Ejemplo de configuración:

```apache
<VirtualHost *:80>
    ServerName decoupled.com
    DocumentRoot /var/www/decoupled/dist

    <Directory /var/www/decoupled/dist>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^ index.html [L]
</VirtualHost>
```

### Pasos para habilitar esta configuración:

1. Copia los archivos estáticos al directorio `/var/www/decoupled/dist`.

2. Asegúrate de habilitar el módulo `mod_rewrite` si no está activado:

   ```bash
   sudo a2enmod rewrite
   sudo systemctl restart apache2
   ```

## Configuración para HTTPS

Para habilitar HTTPS en Apache, necesitas un certificado SSL/TLS. Aquí tienes los pasos básicos:

### 1. Habilitar el módulo SSL

```bash
sudo a2enmod ssl
sudo systemctl restart apache2
```

### 2. Configurar el VirtualHost para HTTPS

Edita o crea un archivo de configuración en `/etc/apache2/sites-available/` para incluir un bloque `VirtualHost` que escuche en el puerto 443:

```apache
<VirtualHost *:443>
    ServerName decoupled.com
    DocumentRoot /var/www/decoupled

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

    <Directory /var/www/decoupled>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/decoupled-error.log
    CustomLog ${APACHE_LOG_DIR}/decoupled-access.log combined
</VirtualHost>
```

### 3. Habilitar el sitio y reiniciar Apache

```bash
sudo a2ensite decoupled-ssl.conf
sudo systemctl restart apache2
```

## Configuración para Balanceo de Carga

Apache no realiza balanceo de carga automáticamente, pero puedes configurarlo habilitando los módulos necesarios y definiendo un VirtualHost para distribuir las solicitudes entre varios servidores backend.

### Pasos para Configurar Balanceo de Carga

1. **Habilitar los módulos necesarios**:

   ```bash
   sudo a2enmod proxy
   sudo a2enmod proxy_balancer
   sudo a2enmod lbmethod_byrequests
   sudo systemctl restart apache2
   ```

2. **Configurar un VirtualHost para balanceo de carga**:
   Edita o crea un archivo en `/etc/apache2/sites-available/` con la siguiente configuración:

   ```apache
   <VirtualHost *:80>
       ServerName decoupled.com

       ProxyPreserveHost On

       <Proxy "balancer://mi_cluster">
           BalancerMember http://192.168.1.101:8080
           BalancerMember http://192.168.1.102:8080
           ProxySet lbmethod=byrequests
       </Proxy>

       ProxyPass / balancer://mi_cluster/
       ProxyPassReverse / balancer://mi_cluster/

       ErrorLog ${APACHE_LOG_DIR}/balanceo-error.log
       CustomLog ${APACHE_LOG_DIR}/balanceo-access.log combined
   </VirtualHost>
   ```

   - `BalancerMember` define los servidores backend que recibirán las solicitudes.
   - `lbmethod=byrequests` distribuye las solicitudes de manera uniforme entre los servidores.

3. **Habilitar el sitio y reiniciar Apache**:
   ```bash
   sudo a2ensite balanceo.conf
   sudo systemctl restart apache2
   ```

Con esta configuración, Apache actuará como un balanceador de carga, distribuyendo las solicitudes entre los servidores backend definidos.
