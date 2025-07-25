# Nginx

Nginx es un servidor web y proxy inverso conocido por su alto rendimiento y bajo consumo de recursos.

## Importancia

- Ideal para manejar grandes cantidades de tráfico.
- Funciona como proxy inverso, balanceador de carga y servidor de contenido estático.
- Compatible con HTTP/2 y SSL/TLS.

## Instalación

En sistemas basados en Debian/Ubuntu:

```bash
sudo apt update
sudo apt install nginx
```

## Configuración básica

El archivo principal de configuración se encuentra en `/etc/nginx/nginx.conf`. Para configurar un sitio web, edita o crea un archivo en `/etc/nginx/sites-available/`.

Ejemplo de configuración para un sitio:

```nginx
server {
    listen 80;
    server_name decoupled.com;
    root /var/www/decoupled;

    location / {
        index index.html;
    }
}
```

Habilita el sitio y reinicia Nginx:

```bash
sudo ln -s /etc/nginx/sites-available/decoupled /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

## Configuración como Proxy Inverso

Si Nginx está configurado como proxy inverso para un servicio que ya está corriendo en un puerto específico (por ejemplo, un frontend servido por PM2 en el puerto 3000), puedes configurar Nginx para redirigir las solicitudes a ese puerto.

Ejemplo de configuración:

```nginx
server {
    listen 80;
    server_name decoupled.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

## Configuración para Archivos Estáticos

Si deseas servir archivos estáticos (por ejemplo, un bundle generado por una herramienta como Vite), puedes configurar Nginx para que apunte al directorio donde se encuentran los archivos.

Ejemplo de configuración:

```nginx
server {
    listen 80;
    server_name decoupled.com;
    root /var/www/decoupled/dist;

    location / {
        index index.html;
        try_files $uri /index.html;
    }
}
```

### Pasos para habilitar esta configuración:

1. Copia los archivos estáticos al directorio `/var/www/decoupled/dist`.

2. Habilita el sitio y reinicia Nginx:

   ```bash
   sudo ln -s /etc/nginx/sites-available/decoupled /etc/nginx/sites-enabled/
   sudo systemctl restart nginx
   ```

## Configuración para Balanceo de Carga

Nginx permite realizar balanceo de carga de manera eficiente y sencilla. Puedes configurar un bloque `upstream` para definir los servidores backend y luego usarlo en un bloque `server`.

### Ejemplo de Configuración para Balanceo de Carga

1. **Configurar un bloque `upstream`**:
   Edita o crea un archivo en `/etc/nginx/sites-available/` con la siguiente configuración:

   ```nginx
   upstream mi_cluster {
       server 192.168.1.101:8080;
       server 192.168.1.102:8080;
   }

   server {
       listen 80;
       server_name decoupled.com;

       location / {
           proxy_pass http://mi_cluster;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       }
   }
   ```

   - `upstream` define los servidores backend que recibirán las solicitudes.
   - `proxy_pass` redirige las solicitudes al bloque `upstream`.

2. **Habilitar el sitio y reiniciar Nginx**:
   ```bash
   sudo ln -s /etc/nginx/sites-available/decoupled /etc/nginx/sites-enabled/
   sudo systemctl restart nginx
   ```

Con esta configuración, Nginx distribuirá las solicitudes entrantes entre los servidores backend definidos en el bloque `upstream`.
