# Sistema de Mensajes - Cliente ↔ Atención al Cliente

## Descripción General
El sistema de mensajes permite que los clientes se comuniquen directamente con el equipo de **Atención al Cliente** a través de la plataforma. Es un canal de soporte bidireccional para consultas, problemas técnicos, y solicitudes especiales.

## Flujo de Funcionamiento

### 1. Cliente envía mensaje
**Ruta:** `/enviar-atencion`
- El cliente accede a "Enviar a Atención" desde su panel
- Completa:
  - **Asunto:** Tema de la consulta
  - **Mensaje:** Descripción detallada del problema
- Al enviar, se crea un registro en la base de datos con:
  - `estado: 'pendiente'` (inicialmente)
  - `tipo_remitente: 'cliente'`
  - `fecha_creacion: (timestamp actual)`

### 2. Equipo de Atención recibe mensaje
**Ruta:** `/bandeja-mensajes` (solo accesible para role "atencion")
- El dashboard muestra:
  - **Total de mensajes** - Todos los enviados
  - **Pendientes** - Mensajes sin responder (amarillo)
  - **Respondidos** - Mensajes con respuesta (verde)
  
### 3. Estados del Mensaje
Un mensaje puede estar en los siguientes estados:

- `pendiente` → Sin revisar aún (🟡 Amarillo)
- `en_proceso` → Siendo atendido (🔵 Azul)
- `respondido` → Ya tiene respuesta (🟢 Verde)

### 4. Atención al Cliente responde
- Selecciona un mensaje pendiente
- Lee el contenido completo del cliente
- Escribe una respuesta en el área de texto
- Hace clic en "Enviar Respuesta"
- El sistema actualiza:
  - `respuesta: (texto enviado)`
  - `estado: 'respondido'`
  - `fecha_respuesta: (timestamp actual)`

### 5. Cliente ve la respuesta
- Accede a `/enviar-atencion`
- En el historial de mensajes ve:
  - Su mensaje original
  - La respuesta del equipo de atención
  - Las fechas de envío y respuesta

## Endpoints de API

### GET /api/mensajes
Obtiene todos los mensajes
```
GET http://localhost:5000/api/mensajes
Response: [
  {
    id: 1,
    asunto: "Problema con reserva",
    contenido: "No puedo hacer una reserva...",
    usuario_id: 5,
    estado: "pendiente",
    respuesta: null,
    fecha_creacion: "2024-01-15T10:30:00Z",
    fecha_respuesta: null,
    tipo_remitente: "cliente"
  },
  ...
]
```

### POST /api/mensajes
Crea un nuevo mensaje
```
POST http://localhost:5000/api/mensajes
Body: {
  asunto: string,
  contenido: string,
  usuario_id: number,
  tipo_remitente: "cliente"
}
Response: { id, asunto, contenido, ... (objeto creado) }
```

### PUT /api/mensajes/:id
Actualiza un mensaje (para agregar respuesta o cambiar estado)
```
PUT http://localhost:5000/api/mensajes/1
Body: {
  respuesta: "Hemos solucionado tu problema...",
  estado: "respondido",
  fecha_respuesta: "2024-01-15T14:00:00Z"
}
Response: { id, asunto, respuesta, estado, ... }
```

### DELETE /api/mensajes/:id
Elimina un mensaje (solo clientes pueden eliminar sus propios mensajes)
```
DELETE http://localhost:5000/api/mensajes/1
Response: { message: "Mensaje eliminado" }
```

## Componentes Frontend

### 1. EnviarAtencion.jsx
**Ubicación:** `/src/pages/EnviarAtencion.jsx`
- Interfaz para clientes enviar mensajes
- Mostra historial de mensajes enviados y respuestas recibidas
- Funciones:
  - `loadMensajes()` - Carga mensajes del usuario actual
  - `handleEnviarMensaje()` - POST a /api/mensajes
  - `handleEliminarMensaje()` - DELETE mensaje

**Features:**
- ✅ Validación de campos (asunto + contenido)
- ✅ Indicador de estados (Pendiente, En proceso, Respondido)
- ✅ Historial con respuestas coloreadas
- ✅ Opción de eliminar mensajes propios

### 2. BandejaMensajesSoporte.jsx
**Ubicación:** `/src/pages/BandejaMensajesSoporte.jsx`
- Interfaz para equipo de atención responder mensajes
- Panel de 3 columnas:
  1. **Lista de mensajes** (lado izquierdo) con filtros
  2. **Detalles del mensaje** (lado derecho) con opciones de respuesta
  3. **Estadísticas** (arriba) con contadores

**Features:**
- ✅ Filtros: Todos, Pendientes, Respondidos
- ✅ Auto-actualización cada 30 segundos
- ✅ Marcar como "En proceso"
- ✅ Enviar respuesta y cambiar estado a "Respondido"
- ✅ Vista de mensaje original + respuesta
- ✅ Timestamps detallados

## Modelos de Base de Datos

### Tabla: mensajes
```sql
CREATE TABLE mensajes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  asunto VARCHAR(255) NOT NULL,
  contenido LONGTEXT NOT NULL,
  usuario_id INT NOT NULL,
  estado ENUM('pendiente', 'en_proceso', 'respondido') DEFAULT 'pendiente',
  respuesta LONGTEXT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_respuesta TIMESTAMP NULL,
  tipo_remitente ENUM('cliente', 'atención') DEFAULT 'cliente',
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);
```

## Estructura de Carpetas
```
frontend/
├── src/
│   ├── pages/
│   │   ├── EnviarAtencion.jsx          (Interfaz cliente)
│   │   └── BandejaMensajesSoporte.jsx  (Interfaz atención)
│   ├── services/
│   │   └── api.js                      (Llamadas HTTP)
│   └── contexts/
│       └── AuthContext.js              (Autenticación/roles)
└── ...

backend/
├── controllers/
│   └── mensajesController.js           (Lógica de mensajes)
├── models/
│   └── Mensaje.js                      (Modelo Sequelize)
├── routes/
│   └── ...                             (Rutas registradas)
└── ...
```

## Acceso por Roles

| Rol | Acceso | Función |
|-----|--------|---------|
| **Cliente** | ✅ `/enviar-atencion` | Enviar mensajes y ver respuestas |
| **ClienteIB1** | ✅ `/enviar-atencion` | Enviar mensajes y ver respuestas |
| **ClienteIB2** | ✅ `/enviar-atencion` | Enviar mensajes y ver respuestas |
| **Atención** | ✅ `/bandeja-mensajes` | Ver, responder y gestionar mensajes |
| **Postventa** | ✅ `/bandeja-mensajes` | Ver, responder y gestionar mensajes |
| **Admin** | ✅ `/bandeja-mensajes` | Ver, responder y gestionar mensajes |

## Cómo Usar

### Para Clientes:
1. Ir a su panel (ej: `/cliente`)
2. En el menú, hacer clic en "Enviar a Atención"
3. Completar "Asunto" y "Mensaje"
4. Hacer clic en "Enviar Mensaje"
5. Ver historial y respuestas en la misma página

### Para Atención al Cliente:
1. Ir a `/dashboard-atencion` (Panel de Atención)
2. Hacer clic en el botón "📧 Bandeja de Mensajes"
3. Ver lista de mensajes con filtros:
   - **Todos:** Todos los mensajes
   - **Pendientes:** Sin revisar
   - **Respondidos:** Con respuesta
4. Hacer clic en un mensaje para verlo completo
5. (Opcional) Marcar como "En proceso" si es complejo
6. Escribir respuesta en el área de texto
7. Hacer clic en "Enviar Respuesta"
8. El sistema actualiza automáticamente

## Testing (Manual)

### Paso 1: Cliente envía mensaje
```
1. Login como cliente
2. /enviar-atencion
3. Asunto: "Problema con mi reserva"
4. Mensaje: "No puedo cambiar las fechas de mi reserva"
5. Click "Enviar Mensaje"
→ Debe aparecer en historial con estado "Pendiente"
```

### Paso 2: Equipo responde
```
1. Login como usuario de atención
2. /dashboard-atencion → Click "Bandeja de Mensajes"
3. Debe ver el mensaje en la lista
4. Click en el mensaje
5. Escribir: "Hemos solucionado tu problema, las fechas están actualizadas"
6. Click "Enviar Respuesta"
→ Debe actualizar el estado a "Respondido"
```

### Paso 3: Cliente ve respuesta
```
1. Login como cliente
2. /enviar-atencion
3. Debe ver el mensaje con la respuesta debajo
4. Estado debe cambiar a "Respondido"
```

## Integración con NotificationBell

El sistema de mensajes se integra con el sistema de notificaciones:
- Cuando un mensaje se responde, se puede crear una notificación
- Los clientes ven un badge en la campana de notificaciones
- El equipo de atención también puede ver nuevos mensajes como notificaciones

(Integración futura con NotificationBell component)

## Troubleshooting

### Los mensajes no se envían
1. Verificar que el backend esté corriendo en `:5000`
2. Revisar la consola del navegador para errores
3. Confirmar que el usuario está autenticado
4. Verificar que el usuario_id se está pasando correctamente

### No aparecen mensajes en la bandeja
1. Confirmar que estás logueado como usuario de atención
2. Verificar que los clientes hayan enviado mensajes
3. Revisar en la BD: `SELECT * FROM mensajes;`

### Respuestas no se guardan
1. Verificar ruta `/api/mensajes/:id` en el backend
2. Confirmar que `PUT` está soportado
3. Revisar status HTTP en DevTools Network tab

## Próximas Mejoras

- [ ] Integración con NotificationBell para nuevos mensajes
- [ ] Notificaciones por email cuando hay respuesta
- [ ] Búsqueda y filtrado avanzado
- [ ] Archivos adjuntos en mensajes
- [ ] Historial de conversaciones agrupadas
- [ ] Tiempo de respuesta promedio por atención
- [ ] Sistema de calificación del servicio
- [ ] Chat en tiempo real (WebSocket)
