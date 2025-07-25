# PM2 _(Node.js)_

PM2 es un manejador de procesos para aplicaciones Node.js que permite ejecutar, monitorear y administrar aplicaciones en producción.

## Importancia

- Permite reinicios automáticos en caso de fallos.
- Proporciona monitoreo en tiempo real de las aplicaciones.
- Soporta balanceo de carga para aplicaciones distribuidas.

## Instalación

Para instalar PM2 globalmente:

```bash
npm install -g pm2
```

## Configuración básica

Para iniciar una aplicación Node.js con PM2:

```bash
pm2 start app.js --name "mi-app"
```

- `--name` permite asignar un nombre a la aplicación para facilitar su identificación.

## Balanceo de carga

PM2 permite balancear la carga de una aplicación en múltiples núcleos de CPU:

```bash
pm2 start app.js -i max --name "mi-app"
```

- `-i max` utiliza todos los núcleos disponibles.

## Persistencia

Para asegurarte de que las aplicaciones se reinicien automáticamente después de un reinicio del sistema:

```bash
pm2 startup
pm2 save
```

Esto generará un script de inicio automático y guardará el estado actual de las aplicaciones.
