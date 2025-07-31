# Preguntas Frecuentes (FAQ)

Aquí encontrarás respuestas a preguntas comunes sobre el proyecto, su arquitectura y su funcionamiento.

### Preguntas Generales

**P: ¿Cuál es el propósito principal de este proyecto?**
**R:** Es una demostración de una aplicación web en tiempo real construida con una arquitectura de microservicios. Sirve como ejemplo práctico de cómo desacoplar componentes (autenticación, lógica de juego, saldos) en servicios independientes que se comunican eficientemente, utilizando un stack tecnológico variado.

**P: ¿Por qué usar microservicios en lugar de una aplicación monolítica?**
**R:** La arquitectura de microservicios ofrece varias ventajas clave para este tipo de aplicación:

- **Escalabilidad**: Cada servicio puede escalarse de forma independiente. Si muchos usuarios están apostando, se pueden crear más instancias del `management_microservice` sin afectar los otros servicios.
- **Resiliencia**: Un fallo en un servicio no crítico (ej. el de autenticación) no detiene el juego para los usuarios ya conectados.
- **Flexibilidad Tecnológica**: Permite usar las mejores herramientas para cada trabajo. Se usa Node.js en el `management_microservice` por su excelente manejo de eventos y WebSockets, mientras que Python se usa en otros microservicios por su robustez para lógica de negocio.
- **Mantenibilidad**: Equipos más pequeños pueden trabajar en servicios individuales de forma autónoma, lo que acelera el desarrollo y facilita las actualizaciones.

### Preguntas de Arquitectura y Técnicas

**P: ¿Cómo se comunican los diferentes servicios entre sí?**
**R:** Se utilizan tres métodos de comunicación principales, cada uno elegido por su idoneidad para la tarea:

1.  **API REST (HTTP)**: El `frontend` se comunica con el `backend` (API Gateway) para operaciones síncronas y sin estado como el login y el registro. Es un estándar web bien conocido y fácil de consumir.
2.  **WebSockets**: El `frontend` mantiene una conexión bidireccional y persistente con el `management_microservice`. Esto es crucial para la jugabilidad en tiempo real, permitiendo al servidor empujar actualizaciones (estado del juego, apuestas de otros, resultados) a los clientes instantáneamente.
3.  **gRPC**: Se utiliza para la comunicación interna entre los servicios del backend. Es un framework de RPC (Remote Procedure Call) de alto rendimiento que usa HTTP/2 y Protocol Buffers, lo que lo hace mucho más rápido y eficiente que REST para la comunicación entre microservicios.

**P: ¿Por qué se usa Redis en esta arquitectura?**
**R:** Redis actúa como una base de datos en memoria de alta velocidad. Su función es gestionar datos volátiles y de acceso extremadamente rápido para no sobrecargar la base de datos SQL principal. Sus usos clave son:

- **Almacenamiento de Apuestas**: Guarda las apuestas de todos los usuarios durante la fase de apuestas de 30 segundos.
- **Gestión de Sesiones**: Mapea las conexiones de Socket.IO a los IDs de usuario, permitiendo saber a quién enviar mensajes privados como la actualización de su saldo.

**P: ¿Cómo se sincroniza el estado del juego (ej. el temporizador) entre todos los jugadores?**
**R:** La sincronización es manejada centralmente por el `GameLoop` en el [`management_microservice/GameLoop.ts`](management_microservice/GameLoop.ts). Este bucle emite eventos de estado a través de WebSockets a todos los clientes conectados. Por ejemplo, cuando comienza la fase de apuestas, emite un evento `GAME_STATE` que incluye la fase actual (`BETTING`) y el tiempo restante. Todos los clientes reciben esta misma información al mismo tiempo, asegurando que sus interfaces estén sincronizadas.

### Preguntas de Funcionalidad

**P: ¿Cómo se determina el número ganador? ¿Es realmente aleatorio?**
**R:** El número ganador se determina de forma pseudoaleatoria en el servidor para garantizar la equidad y evitar trampas desde el cliente. El `management_microservice` genera una velocidad inicial aleatoria para la ruleta. Esta velocidad se envía al frontend para que la animación sea consistente, pero el cálculo final del número ganador se realiza en el backend, como se ve en la clase [`RouletteService`](management_microservice/services/RouletteService.ts).

**P: ¿Cómo se calculan las ganancias?**
**R:** Después de que se determina un número ganador, el método `calculateSpinResults` en [`management_microservice/services/RouletteService.ts`](management_microservice/services/RouletteService.ts) itera sobre todas las apuestas almacenadas en Redis. Para cada apuesta, la función `calculateBetWinnings` determina si es ganadora y calcula el pago según el tipo de apuesta (ej. 35:1 para un número específico, 2:1 para una docena, 1:1 para rojo/negro).

**P: ¿Puedo añadir saldo a mi cuenta?**
**R:** Sí. En la interfaz de usuario, hay un botón "Add Balance" que simula una recarga. En una aplicación real, esto redirigiría a una pasarela de pago. En este proyecto, al hacer clic, se podría implementar una llamada al método `AddBalance` del [`balance_microservice/src/service/service.py`](balance_microservice/src/service/service.py) para incrementar el saldo del usuario.

### Desarrollo y Despliegue

**P: ¿Cómo puedo ver los logs de un servicio específico mientras se ejecuta?**
**R:** Puedes usar el comando `docker-compose logs` con el flag `-f` para seguir los logs en tiempo real.

```bash
# Ejemplo para ver los logs del management_microservice en tiempo real
docker-compose logs -f management_microservice
```

**P: ¿Qué necesito para desplegar esto en un servidor de producción?**
**R:** Los requisitos principales son **Docker** y **Docker Compose** en tu servidor. Los pasos se detallan en la sección "Despliegue en Producción" del [`README.md`](README.md), pero en resumen: clonas el repositorio, ejecutas `docker-compose up --build -d`, y configuras un reverse proxy (como Nginx) para dirigir
