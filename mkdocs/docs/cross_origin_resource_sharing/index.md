# El mejor amigo del desarrollador

CORS (Intercambio de Recursos de Origen Cruzado por sus siglas) es un mecanismo de seguridad implementado en los navegadores web que controla cómo una aplicación web en un dominio (origen) puede solicitar recursos (como APIs, fuentes o imágenes) desde otro dominio diferente. Por defecto, los navegadores aplican la política del mismo origen (Same-Origin Policy), que bloquea peticiones HTTP entre dominios distintos como medida de seguridad para evitar ataques como CSRF (Cross-Site Request Forgery) o robo de datos. CORS relaja esta restricción de manera controlada, permitiendo comunicación segura entre orígenes.

Cuando un frontend (ej: `https://decoupled.dev`) intenta acceder a una API en otro dominio (ej: `https://api.decoupled.dev`), el navegador envía una petición preflight (OPTIONS) para verificar si el servidor permite solicitudes desde el origen del frontend. El servidor debe responder con cabeceras HTTP como Access-Control-Allow-Origin que especifiquen qué dominios, métodos (GET, POST) o cabeceras están permitidos. Si no se configuran correctamente, el navegador bloqueará la respuesta por motivos de seguridad.

### **Profundizando en CORS: Mecanismos, Configuración y Buenas Prácticas**

Cuando se realiza una petición entre dominios, el navegador sigue un protocolo estricto:

**a) Peticiones Simples (Simple Requests)**  
Solo aplican para métodos GET, HEAD o POST con ciertos tipos de contenido. El navegador envía la petición directamente incluyendo la cabecera:
```http
Origin: https://decoupled.dev
```
El servidor debe responder con:
```http
Access-Control-Allow-Origin: https://decoupled.dev
Access-Control-Allow-Credentials: true  // Si se usan cookies
```

**b) Peticiones Preflight (OPTIONS)**  
Para métodos PUT, DELETE o POST con contenido JSON, el navegador primero envía una petición OPTIONS con:
```http
Origin: https://decoupled.dev
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type
```
El servidor debe responder con:
```http
Access-Control-Allow-Origin: https://decoupled.dev
Access-Control-Allow-Methods: POST, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type
Access-Control-Max-Age: 86400  // Cache por 24h
```

### Configuraciones Avanzadas en Backend
**Ejemplo en Node.js (Express):**
```javascript
const corsOptions = {
  origin: 'https://decoupled.dev',
  methods: ['GET', 'POST', 'PUT'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
  maxAge: 86400
};
app.use(cors(corsOptions));
```

**Ejemplo en Nginx:**
```nginx
location /api {
    if ($request_method = OPTIONS) {
        add_header 'Access-Control-Allow-Origin' 'https://decoupled.dev';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization';
        return 204;
    }
}
```

### Escenarios Comunes y Soluciones
| Escenario | Problema | Solución |
|-----------|---------|----------|
| Desarrollo local | Frontend (localhost:3000) → API (localhost:5000) | Usar `cors({ origin: 'http://localhost:3000' })` |
| Microservicios | API Gateway (api.example.com) → Servicio (auth.example.com) | Configurar CORS en el gateway |
| AWS S3/CloudFront | Acceso a recursos estáticos desde múltiples dominios | Especificar `AllowedOrigins` en la política CORS del bucket |

### Seguridad y Buenas Prácticas
- **Nunca uses `Access-Control-Allow-Origin: *`** en producción con credenciales (cookies, tokens).
- **Validación estricta de orígenes**: Usar listas blancas (whitelists) en lugar de permitir cualquier origen.
- **Cabeceras sensibles**: Limita el acceso a cabeceras como `Authorization` con `exposedHeaders`.
- **Pruebas de seguridad**: Verifica configuraciones incorrectas con herramientas como OWASP ZAP.

**Ejemplo de validación segura en Express:**
```javascript
const allowedOrigins = ['https://decoupled.dev', 'https://staging.decoupled.dev'];
app.use(cors({
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Origen no permitido por CORS'));
    }
  }
}));
```

### Casos Especiales
- **WebSockets**: No están sujetos a CORS (usan política diferente).
- **Cookies entre dominios**: Requieren `Access-Control-Allow-Credentials: true` y orígenes explícitos (no wildcard `*`).
- **Caching de Preflight**: Optimiza con `Access-Control-Max-Age`.
