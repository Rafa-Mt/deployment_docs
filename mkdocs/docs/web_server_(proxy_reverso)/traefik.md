# Traefik

Traefik es un proxy inverso moderno diseñado para integrarse fácilmente con entornos de contenedores como Docker y Kubernetes.

## Importancia

- Configuración dinámica basada en etiquetas o anotaciones.
- Soporte nativo para Let's Encrypt y HTTP/2.
- Ideal para arquitecturas basadas en microservicios.

## Instalación

Con Docker:

```bash
docker run -d -p 80:80 -p 443:443 -p 8080:8080 \
  --name traefik \
  -v $PWD/traefik.yml:/etc/traefik/traefik.yml \
  traefik
```

## Configuración básica

Ejemplo de archivo `traefik.yml`:

```yaml
entryPoints:
  web:
    address: ":80"
  websecure:
    address: ":443"

providers:
  docker:
    exposedByDefault: false

certificatesResolvers:
  letsencrypt:
    acme:
      email: admin@decoupled.com
      storage: acme.json
      httpChallenge:
        entryPoint: web
```

Asegúrate de montar el archivo de configuración y reiniciar el contenedor si realizas cambios.

## Configuración como Proxy Inverso

Si Traefik está configurado como proxy inverso para un servicio que ya está corriendo en un puerto específico (por ejemplo, un frontend servido por PM2 en el puerto 3000), puedes configurar Traefik para redirigir las solicitudes a ese puerto.

Ejemplo de configuración en `traefik.yml`:

```yaml
http:
  routers:
    my-service:
      rule: "Host(`decoupled.com`)"
      service: my-service

  services:
    my-service:
      loadBalancer:
        servers:
          - url: "http://localhost:3000"
```

### Pasos para habilitar esta configuración:

1. Asegúrate de que el archivo `traefik.yml` esté montado correctamente en el contenedor de Traefik.

2. Reinicia el contenedor de Traefik para aplicar los cambios:

   ```bash
   docker restart traefik
   ```

## Configuración para Archivos Estáticos

Si deseas servir archivos estáticos (por ejemplo, un bundle generado por una herramienta como Vite), puedes configurar Traefik para que apunte al directorio donde se encuentran los archivos.

Ejemplo de configuración en `traefik.yml`:

```yaml
http:
  routers:
    static-files:
      rule: "Host(`decoupled.com`)"
      service: static-files

  services:
    static-files:
      loadBalancer:
        servers:
          - url: "file:///var/www/decoupled/dist"
```

### Pasos para habilitar esta configuración:

1. Copia los archivos estáticos al directorio `/var/www/decoupled/dist` en el servidor.

2. Reinicia el contenedor de Traefik para aplicar los cambios:

   ```bash
   docker restart traefik
   ```
