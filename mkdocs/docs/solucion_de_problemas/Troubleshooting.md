# Guía de Solución de Problemas (Troubleshooting)

Este documento te ayudará a diagnosticar y resolver problemas comunes que pueden surgir durante la instalación, ejecución o uso del proyecto de ruleta online.

## Problemas con Docker y Docker Compose

#### Error: `Service '...' failed to build`

Este error indica que Docker no pudo construir la imagen para uno de los servicios.

- **Causa Posible 1**: Problemas de red al descargar dependencias (ej. paquetes `npm` o `pip`).
- **Solución**: Verifica tu conexión a internet. Intenta ejecutar el comando de nuevo. Si el problema persiste, puedes forzar una reconstrucción sin caché:

  ```bash
  docker-compose build --no-cache <nombre_del_servicio>
  docker-compose up -d
  ```

- **Causa Posible 2**: Un error en el `Dockerfile` del servicio.
- **Solución**: Revisa el `Dockerfile` del servicio que falla en busca de errores de sintaxis o comandos incorrectos.

#### Error: `Container for service '...' is unhealthy` o se reinicia constantemente

Esto significa que un contenedor se inició pero no pasó la verificación de estado (healthcheck) o se cerró inesperadamente.

- **Causa Común**: El servicio no pudo conectarse a una de sus dependencias (ej. el `backend` no puede conectarse a un microservicio gRPC, o un microservicio no puede conectarse a Redis).
- **Solución**: Revisa los logs del contenedor que está fallando para identificar el error exacto.
  ```bash
  # Reemplaza <nombre_del_servicio> con el servicio problemático (ej. backend, management_microservice)
  docker-compose logs <nombre_del_servicio>
  ```
  Busca mensajes de error como `Connection refused`, `Service Unavailable` o errores de inicialización.

#### Error: `Port is already allocated` o `Address already in use`

- **Causa**: Uno de los puertos que el proyecto intenta usar ya está ocupado por otra aplicación en tu máquina.
  - Frontend: `3210` (definido en [`frontend/ecosystem.config.cjs`](frontend/ecosystem.config.cjs))
  - Backend: `3000`
- **Solución**: Detén la aplicación que está usando el puerto conflictivo o cambia el puerto en el archivo `docker-compose.yml` (para el backend) o en [`frontend/ecosystem.config.cjs`](frontend/ecosystem.config.cjs) (para el frontend).

## Problemas de la Aplicación

#### El frontend carga, pero el Login/Registro falla con un error de red

- **Síntoma**: Al intentar iniciar sesión o registrarse, la interfaz muestra un error y la consola del navegador muestra un `POST` a `http://localhost:3000/...` fallido.
- **Causa**: El frontend no puede comunicarse con el API Gateway (`backend`).
- **Pasos para Solucionar**:
  1.  **Verifica que el backend esté corriendo**:
      ```bash
      docker-compose ps
      ```
      Asegúrate de que el estado del contenedor `backend` sea `Up`.
  2.  **Revisa los logs del backend**:
      ```bash
      docker-compose logs backend
      ```
      Busca cualquier error que haya ocurrido durante el inicio del servidor Express.
  3.  **Verifica la comunicación gRPC**: Si el backend está corriendo pero falla al procesar la solicitud, el problema puede ser la comunicación con el `auth_microservice`. Revisa los logs de ambos servicios.

#### El usuario inicia sesión, pero el juego no funciona (la ruleta no gira, el temporizador no avanza)

- **Síntoma**: La página principal se carga después del login, pero no hay actualizaciones en tiempo real. No se ven las apuestas de otros jugadores ni el estado del juego cambia.
- **Causa**: La conexión WebSocket con el `management_microservice` no se pudo establecer o se interrumpió.
- **Pasos para Solucionar**:
  1.  **Verifica que el `management_microservice` esté corriendo**:
      ```bash
      docker-compose ps
      ```
  2.  **Revisa los logs del `management_microservice`**:
      ```bash
      docker-compose logs management_microservice
      ```
      Busca errores de conexión con Redis o problemas al iniciar el servidor de Socket.IO.
  3.  **Revisa la consola del navegador**: Abre las herramientas de desarrollador, ve a la pestaña "Network" (Red) y filtra por "WS" (WebSockets). Deberías ver una conexión establecida. Si está en rojo o no aparece, la conexión falló.

#### Las apuestas se realizan pero el saldo no se actualiza correctamente

- **Síntoma**: Un usuario realiza una apuesta, pero su saldo no disminuye, o después de ganar una ronda, el saldo no aumenta.
- **Causa**: El `management_microservice` no puede comunicarse con el `balance_microservice` a través de gRPC.
- **Pasos para Solucionar**:
  1.  **Revisa los logs del `management_microservice`**: Busca errores relacionados con llamadas gRPC al intentar validar o pagar una apuesta.
      ```bash
      docker-compose logs management_microservice
      ```
  2.  **Revisa los logs del `balance_microservice`**: Asegúrate de que el servicio gRPC de Python se esté ejecutando sin errores.
      ```bash
      docker-compose logs balance_microservice
      ```
