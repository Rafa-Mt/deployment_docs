# PM2 _(Node.js)_

PM2 es un administrador de procesos avanzado para aplicaciones Node.js y otros entornos JavaScript. Permite ejecutar, monitorear y administrar aplicaciones en producción de manera sencilla y eficiente. Es ideal para mantener tus servicios corriendo de forma estable, reiniciarlos automáticamente ante fallos y facilitar el despliegue en servidores.

## ¿Por qué usar PM2?

PM2 ofrece varias ventajas para la administración de aplicaciones en producción:

- **Ejecución como servicio:** Tus aplicaciones se mantienen activas incluso si cierras la terminal o el servidor se reinicia.
- **Reinicio automático:** Si la aplicación falla, PM2 la reinicia automáticamente, mejorando la disponibilidad.
- **Monitoreo y administración:** Puedes ver el estado, consumo de recursos y logs de cada proceso en tiempo real.
- **Gestión de múltiples procesos:** Permite ejecutar varias instancias de una misma app (cluster) o diferentes apps simultáneamente.
- **Manejo de logs y métricas:** Centraliza los logs y facilita la integración con herramientas externas.

## Instalación

PM2 se instala globalmente usando npm. Es recomendable tener Node.js instalado previamente.

```bash
npm install pm2 -g
```

Puedes verificar la instalación con:

```bash
pm2 --version
```

## Comandos básicos

### Iniciar una aplicación

Inicia tu aplicación Node.js (o cualquier script compatible):

```bash
pm2 start app.js
```

Puedes especificar el nombre del proceso para identificarlo fácilmente:

```bash
pm2 start app.js --name "mi-app"
```

### Listar procesos

Muestra todos los procesos gestionados por PM2:

```bash
pm2 list
```

### Detener una aplicación

Detiene el proceso sin eliminarlo de la lista:

```bash
pm2 stop mi-app
```

### Reiniciar una aplicación

Reinicia el proceso, útil para aplicar cambios en el código:

```bash
pm2 restart mi-app
```

### Eliminar una aplicación de PM2

Elimina el proceso de la lista y lo detiene:

```bash
pm2 delete mi-app
```

## Monitoreo y administración

PM2 facilita el monitoreo y la administración de tus aplicaciones:

### Ver logs

Muestra los logs en tiempo real de todos los procesos:

```bash
pm2 logs
```

Puedes filtrar por nombre de proceso:

```bash
pm2 logs mi-app
```

### Monitoreo en tiempo real

Abre una interfaz interactiva en la terminal para ver el uso de CPU, memoria y estado de cada proceso:

```bash
pm2 monit
```

## Ejecutar aplicaciones en modo cluster

El modo cluster permite ejecutar varias instancias de una aplicación, distribuyéndolas entre los núcleos disponibles del servidor. Esto mejora el rendimiento y la tolerancia a fallos.

Ejemplo para usar todos los núcleos:

```bash
pm2 start app.js -i max
```

También puedes especificar el número de instancias:

```bash
pm2 start app.js -i 4
```

## Persistencia de procesos (Arranque automático)

Para que PM2 restaure automáticamente los procesos tras un reinicio del sistema, sigue estos pasos:

1. Genera el script de inicio según tu sistema operativo:

```bash
pm2 startup
```

2. Guarda el estado actual de los procesos:

```bash
pm2 save
```

Esto asegura que tus aplicaciones se reinicien automáticamente al arrancar el servidor.

## Exportar y restaurar configuración

PM2 permite guardar el estado de los procesos y restaurarlo fácilmente:

- **Exportar:** Guarda la configuración actual de los procesos en un archivo interno.

```bash
pm2 save
```

- **Restaurar:** Recupera los procesos guardados previamente.

```bash
pm2 resurrect
```

## Ecosistema de aplicaciones con PM2 (ecosystem.config.js)

PM2 permite gestionar múltiples aplicaciones y configuraciones avanzadas mediante un archivo especial llamado `ecosystem.config.js` (o `.json`). Este archivo facilita el despliegue y administración de varios servicios desde un solo comando.

### Ejemplo básico de ecosystem.config.js

```js
module.exports = {
  apps: [
    {
      name: "api",
      script: "api.js",
      instances: 2,
      exec_mode: "cluster",
    },
    {
      name: "web",
      script: "web.js",
      instances: 1,
    },
  ],
};
```

### Cómo usarlo

1. Crea el archivo `ecosystem.config.js` en la raíz de tu proyecto.
2. Inicia todas las aplicaciones definidas con:
   ```bash
   pm2 start ecosystem.config.js
   ```
3. Puedes administrar los procesos como siempre (`pm2 list`, `pm2 stop api`, etc.).

Este método es ideal para proyectos con varios servicios, microservicios o APIs que deben ejecutarse y gestionarse juntos.

-----

## PM2 y Docker

Integrar **PM2** con **Docker** te permite combinar la gestión de procesos robusta de PM2 con la portabilidad y el aislamiento de Docker, creando entornos de despliegue muy eficientes y escalables.

Cuando usas PM2 dentro de un contenedor Docker, puedes aprovechar sus funcionalidades como el reinicio automático, el modo cluster y el monitoreo, mientras Docker se encarga de empaquetar tu aplicación y sus dependencias en un entorno consistente.

### PM2 Runtime en Docker

**`pm2 runtime`** es un comando específico de PM2 diseñado para ejecutarse dentro de contenedores Docker. A diferencia de `pm2 start`, que está pensado para ejecutar PM2 como un demonio en el host, `pm2 runtime`:

  * **No demoniza el proceso:** Se ejecuta en primer plano, lo que permite que Docker lo gestione como el proceso principal del contenedor. Esto es crucial para que Docker pueda monitorear la salud de tu aplicación y detener el contenedor si el proceso de PM2 finaliza.
  * **Encapsula la lógica de inicio:** Facilita la ejecución de tus aplicaciones (o tu archivo `ecosystem.config.js`) directamente, sin necesidad de comandos adicionales para mantener PM2 vivo.
  * **Manejo de señales:** `pm2 runtime` maneja correctamente las señales de `SIGINT` y `SIGTERM` enviadas por Docker al detener o reiniciar un contenedor, asegurando un apagado limpio de tus aplicaciones.

### Dockerfile con `pm2 runtime`

Este es el Dockerfile utilizado para construir el frontend the la aplicación de ruleta.

```dockerfile
# Multi-stage build for production optimization

# Stage 1: Build the application
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev dependencies for build)
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Production runtime
FROM node:20-alpine AS production

# Install PM2 globally and serve
RUN npm install -g pm2 serve

# Set working directory
WORKDIR /app

# Copy built application from builder stage
COPY --from=builder /app/dist ./dist

# Copy PM2 ecosystem configuration
COPY ecosystem.config.cjs ./

# Expose port 3210 (as defined in ecosystem.config.cjs)
EXPOSE 3210

# Start the application with PM2
CMD ["pm2-runtime", "start", "ecosystem.config.cjs"]

```

**Ventajas de usar `pm2 runtime` en Docker:**

  * **Contenedores ligeros:** Al no demonizar PM2, se reduce la complejidad y se mantiene un solo proceso principal por contenedor, lo cual es la mejor práctica de Docker.
  * **Gestión de Logs:** Los logs de tus aplicaciones gestionados por PM2 se redirigen a `stdout`/`stderr` del contenedor, lo que permite que Docker y tus herramientas de orquestación (como Kubernetes o Docker Compose) los recolecten y procesen fácilmente.
  * **Soporte de `ecosystem.config.js`:** Puedes seguir utilizando tu archivo de configuración de PM2 (`ecosystem.config.js`) para gestionar múltiples procesos o configuraciones avanzadas dentro de un solo contenedor Docker si tu arquitectura lo requiere, aunque la práctica común de Docker es un proceso por contenedor.

La combinación de PM2 y Docker (`pm2 runtime` en particular) te proporciona un poderoso mecanismo para desplegar y gestionar tus aplicaciones Node.js de manera confiable, escalable y con una excelente observabilidad en entornos de producción.


## Recursos útiles

- [Documentación oficial de PM2](https://pm2.keymetrics.io/)
- [Guía rápida de PM2](https://pm2.keymetrics.io/docs/usage/quick-start/)
- [PM2 en GitHub](https://github.com/Unitech/pm2)
