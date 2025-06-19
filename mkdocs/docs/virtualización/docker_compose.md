# Docker compose

Docker Compose es una herramienta para definir y ejecutar aplicaciones de múltiples contenedores. Utiliza un único archivo de configuración YAML. Luego, con un solo comando, puedes crear y ejecutar todos los contenedores definidos en ese archivo.

## Estructura de un archivo `docker-compose.yml`

### Servicios

Un servicio es una definición de un contenedor que se ejecutará. Cada servicio puede tener su propia imagen, configuración de red, volúmenes, etc.

### Volúmenes
Los volúmenes son utilizados para persistir datos generados por y utilizados por contenedores. Se definen en la sección `volumes` y pueden ser montados en uno o más servicios.

### Redes
Las redes permiten que los contenedores se comuniquen entre sí. Docker Compose crea una red por defecto, pero puedes definir redes personalizadas si es necesario.

## Ejemplo

Este archivo define tres servicios: un frontend, un backend y una base de datos. El frontend es un servidor Nginx, el backend es una aplicación que se conecta a la base de datos PostgreSQL.

```yaml
services:
  frontend:
    image: nginx:latest
    ports:
      - "80:80"

  backend:
    image: my-backend-image:latest
    environment:
      - DATABASE_URL=postgres://db:5432/mydb
    ports:
      - "5000:5000"
    depends_on:
      - db

  db:
    image: postgres:latest
    # env file
    env_file: .env
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

## Comandos Básicos

Para iniciar los servicios definidos en el archivo `docker-compose.yml`, utiliza:

```bash
docker compose up
```

Si deseas volver a crear los contenedores y aplicar cambios en la configuración, puedes la opción `--build`:


Para detener los servicios, utiliza:

```bash
docker compose down
```

Para monitorizar los logs de todos los servicios, utiliza:

```bash
docker compose logs
```





