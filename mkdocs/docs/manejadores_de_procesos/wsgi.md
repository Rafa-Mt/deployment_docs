# WSGI Servers _(Python)_

Los servidores WSGI son esenciales para ejecutar aplicaciones web Python en producción. Actúan como intermediarios entre la aplicación y el servidor web.

## Importancia

- Permiten ejecutar aplicaciones Python de manera eficiente en entornos de producción.
- Soportan múltiples solicitudes concurrentes.
- Compatibles con frameworks como Flask y Django.

## Instalación

Uno de los servidores WSGI más populares es Gunicorn. Para instalarlo:

```bash
pip install gunicorn
```

## Configuración básica

Para iniciar una aplicación Flask con Gunicorn:

```bash
gunicorn -w 4 -b 0.0.0.0:8000 app:app
```

- `-w 4` especifica el número de trabajadores.
- `-b 0.0.0.0:8000` define la dirección y el puerto.

## Integración con Nginx

Para usar Gunicorn detrás de Nginx, configura un bloque de servidor en Nginx:

```nginx
server {
    listen 80;
    server_name decoupled.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

Esto redirige las solicitudes de Nginx al servidor Gunicorn.
