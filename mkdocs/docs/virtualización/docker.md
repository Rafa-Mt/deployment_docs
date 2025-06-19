# Docker

Es una plataforma de software que simplifica la creación, despliegue y ejecución de aplicaciones mediante **contenedores**.

## ¿Qué es un contenedor?

Un contenedor es una unidad estandarizada de software que empaqueta el código de una aplicación y todas sus dependencias (librerías, configuraciones, etc.) para que se ejecute de manera consistente en cualquier entorno. 

Las imágenes de contenedor se convierten en contenedores en tiempo de ejecución, proporcionando un entorno aislado y ligero para la aplicación. A diferencia de las máquinas virtuales, los contenedores comparten el mismo kernel del sistema operativo anfitrión, lo que los hace más eficientes en términos de recursos y velocidad de arranque.

![Que es un contenedor](container-what-is-container-1110x961.avif)

## Dockerfile

El Dockerfile es un archivo de texto que contiene una serie de instrucciones para construir una imagen de Docker. Cada instrucción en el Dockerfile crea una capa en la imagen, lo que permite un proceso de construcción eficiente y reutilizable.

### Principales instrucciones del Dockerfile

1. Imagen base: Define la imagen base a partir de la cual se construirá la nueva imagen. Por ejemplo, `FROM ubuntu:20.04` o `FROM python:3.12`. 
2. Directorio de trabajo: Establece el directorio de trabajo dentro del contenedor. Por ejemplo, `WORKDIR /app`.
3. Copiar archivos: Copia archivos desde el sistema anfitrión al contenedor. Por ejemplo, `COPY . /app`.
4. Correr comandos: Ejecuta comandos dentro del contenedor durante la construcción de la imagen. Usa `RUN` para ejecutar comandos como `RUN npm install`.
5. Exponer puertos: Expone puertos específicos del contenedor para que puedan ser accedidos desde el exterior. Por ejemplo, `EXPOSE 80`.

#### Ejemplo de Dockerfile

Este es el Dockerfile que se utiliza para construir la imagen de esta documentación:

```dockerfile
# Build stage
FROM python:3.11-alpine as builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

COPY mkdocs/ .

RUN /root/.local/bin/mkdocs build --site-dir /app/site

# Runtime stage
FROM nginx:alpine
COPY --from=builder /app/site /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

```

### Construir una imagen desde un Dockerfile

Para construir una imagen de Docker a partir de un Dockerfile, utiliza el siguiente comando en la terminal:

```bash
docker build -t nombre_imagen .
```

### Ejecutar un contenedor desde una imagen

Para ejecutar un contenedor a partir de una imagen, utiliza el siguiente comando:

```bash
docker run -d -p 80:80 nombre_imagen
```

Donde `-d` ejecuta el contenedor en segundo plano y `-p 80:80` mapea el puerto 80 del contenedor al puerto 80 del sistema anfitrión.