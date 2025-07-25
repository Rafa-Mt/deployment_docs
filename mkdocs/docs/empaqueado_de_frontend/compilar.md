# Compilando y exponiendo el servidor de vite

Vite es una herramienta moderna de construcción de frontend que permite un desarrollo rápido y eficiente. A continuación, se describen los pasos necesarios para compilar y exponer un proyecto utilizando Vite.

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalados los siguientes elementos:

1. **Node.js**: Descárgalo e instálalo desde [nodejs.org](https://nodejs.org/).
2. **Gestor de paquetes npm o yarn**: Estos vienen incluidos con Node.js.
3. **Vite**: Si aún no lo tienes, puedes instalarlo globalmente con el siguiente comando:
    ```bash
    npm install -g create-vite
    ```

## Pasos para Compilar el Proyecto

1. **Instalar Dependencias**  
Asegúrate de que todas las dependencias del proyecto estén instaladas ejecutando:  
```bash
npm install
```

2. **Construir el Proyecto**  
Para compilar el proyecto y generar los archivos estáticos listos para producción, utiliza el comando:
```bash
npm run build
```
Esto generará una carpeta llamada `dist` que contiene los archivos optimizados.

## Exponer el Servidor

Una vez que el proyecto está compilado, puedes exponerlo de varias maneras. Aquí hay algunas opciones comunes:

### 1. **Usar un Servidor Estático Local**
Puedes usar un servidor estático como `serve` para probar los archivos localmente:
```bash
npm install -g serve
serve -s dist
```
Esto iniciará un servidor local y expondrá tu aplicación en una URL como `http://localhost:5000`.

### 2. **Desplegar en un Servidor Web**
Sube los archivos de la carpeta `dist` a un servidor web como Nginx, Apache o cualquier servicio de hosting.

**Ejemplo con Apache**:  
- Copia los archivos de `dist` al directorio raíz de tu servidor web.  
- Configura Apache para servir los archivos editando el archivo de configuración del sitio (por ejemplo, `000-default.conf`):  
    ```apache
    <VirtualHost *:80>
        ServerName decoupled.dev
        DocumentRoot "/decoupled/frontend/dist"

        <Directory "/decoupled/frontend/dist">
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
- Asegúrate de habilitar el módulo `mod_rewrite` si no está activado:
    ```bash
    a2enmod rewrite
    systemctl restart apache2
    ```

### Dockerizando el frontend



## Consideraciones Finales

- Asegúrate de configurar correctamente las rutas en tu aplicación si utilizas un `base` diferente en Vite. Esto se puede hacer en el archivo `vite.config.js`:
```javascript
export default {
    base: '/ruta-base/',
};
```

- Verifica que los archivos generados en `dist` estén optimizados y listos para producción.

