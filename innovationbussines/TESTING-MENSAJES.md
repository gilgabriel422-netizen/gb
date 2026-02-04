# Guía de Prueba del Sistema de Mensajes

## Requisitos
- Backend corriendo en `http://localhost:5000`
- Frontend corriendo en `http://localhost:3000`
- Base de datos PostgreSQL inicializada

## Pasos para Probar

### 1. Verificar Base de Datos
Confirma que la tabla `mensajes` existe:

```sql
SELECT * FROM "mensajes";
```

Si no existe, el backend la creará automáticamente al iniciarse.

### 2. Test 1: Cliente envía mensaje

**Credenciales:**
- Email: `cliente@ejemplo.com` (o cualquier usuario con rol cliente)
- Password: La contraseña registrada

**Acciones:**
1. Ir a `http://localhost:3000/`
2. Hacer login
3. Ir a `/enviar-atencion` (desde el panel del cliente)
4. Llenar formulario:
   - Asunto: "Prueba de sistema de mensajes"
   - Mensaje: "Este es un mensaje de prueba para verificar que el sistema funciona"
5. Click en "Enviar Mensaje"

**Resultado Esperado:**
- ✅ Mensaje "¡Mensaje enviado exitosamente!"
- ✅ Formulario se limpia
- ✅ Mensaje aparece en el historial abajo

**Si no funciona:**
- Abrir DevTools (F12) → Network tab
- Buscar POST `/api/mensajes`
- Revisar status code y response
- Verificar que `usuario_id` se está enviando correctamente

---

### 3. Test 2: Equipo de Atención ve el mensaje

**Credenciales:**
- Email: `atencion@crm.com` (usuario con rol "atencion")
- Password: `password123` o la que esté en la BD

**Acciones:**
1. Ir a `http://localhost:3000/admin-login`
2. Login como usuario de atención
3. Hacer click en "🔔 Panel de Atención" o ir directamente a `/dashboard-atencion`
4. Hacer click en el botón "📧 Bandeja de Mensajes"
5. Debería ver la lista de mensajes

**Resultado Esperado:**
- ✅ Página carga con lista de mensajes
- ✅ Aparece el mensaje que enviamos en Test 1
- ✅ Contador de "Pendientes" es 1
- ✅ El mensaje tiene estado "Pendiente" (amarillo)

**Si no funciona:**
- DevTools → Network tab → GET `/api/mensajes`
- Verificar que status es 200
- Confirmar que el response incluye los mensajes

---

### 4. Test 3: Responder mensaje

**Acciones:**
1. (Continuando desde Test 2, en `/bandeja-mensajes`)
2. Hacer click en el mensaje "Prueba de sistema de mensajes"
3. En el lado derecho, debe aparecer el contenido del mensaje
4. En el área de texto, escribir una respuesta:
   ```
   Hola! Hemos recibido tu mensaje y estamos investigando.
   Te contactaremos dentro de 24 horas con una solución.
   ```
5. Hacer click en "Enviar Respuesta"

**Resultado Esperado:**
- ✅ Alerta "Respuesta enviada exitosamente"
- ✅ El área de respuesta se reemplaza con un panel verde
- ✅ Se muestra la respuesta escrita
- ✅ El estado del mensaje cambia a "Respondido" (verde)
- ✅ En contador arriba: "Respondidos" sube a 1, "Pendientes" baja a 0

**Si no funciona:**
- DevTools → Network tab → PUT `/api/mensajes/[id]`
- Verificar que status es 200
- Confirmar que el body incluye `respuesta` y `estado: 'respondido'`

---

### 5. Test 4: Cliente ve la respuesta

**Acciones:**
1. Cambiar tabs/ventanas al navegador con sesión del cliente
2. Ir a `/enviar-atencion` (refrescar si es necesario)
3. En el historial, debería ver el mensaje con la respuesta

**Resultado Esperado:**
- ✅ El mensaje original aparece con estado "Respondido" (verde)
- ✅ Debajo aparece un panel verde que dice "Respuesta del equipo de atención:"
- ✅ La respuesta escrita aparece en ese panel
- ✅ Se muestra la fecha y hora de respuesta

**Si no funciona:**
- DevTools → Network tab → GET `/api/mensajes`
- Verificar que el mensaje incluye campo `respuesta` con el contenido
- Confirmar que el estado es `respondido`

---

## Script de Testing Automatizado (Backend)

Si quieres probar desde cURL:

### 1. Crear mensaje
```bash
curl -X POST http://localhost:5000/api/mensajes \
  -H "Content-Type: application/json" \
  -d '{
    "asunto": "Prueba cURL",
    "contenido": "Este es un mensaje de prueba desde cURL",
    "usuario_id": 5,
    "tipo_remitente": "cliente"
  }'
```

Respuesta esperada:
```json
{
  "id": 1,
  "asunto": "Prueba cURL",
  "contenido": "Este es un mensaje de prueba desde cURL",
  "usuario_id": 5,
  "estado": "pendiente",
  "respuesta": null,
  "fecha_creacion": "2024-01-15T10:30:00.000Z",
  "fecha_respuesta": null,
  "tipo_remitente": "cliente"
}
```

### 2. Obtener todos los mensajes
```bash
curl -X GET http://localhost:5000/api/mensajes \
  -H "Content-Type: application/json"
```

Respuesta esperada: Array de mensajes

### 3. Responder un mensaje
```bash
curl -X PUT http://localhost:5000/api/mensajes/1 \
  -H "Content-Type: application/json" \
  -d '{
    "respuesta": "Gracias por tu mensaje, lo hemos recibido.",
    "estado": "respondido",
    "fecha_respuesta": "'$(date -u +'%Y-%m-%dT%H:%M:%S.000Z')'"
  }'
```

### 4. Eliminar un mensaje
```bash
curl -X DELETE http://localhost:5000/api/mensajes/1 \
  -H "Content-Type: application/json"
```

---

## Checklist de Validación

- [ ] El formulario en `/enviar-atencion` valida campos (no permite vacíos)
- [ ] Los mensajes se guardan en BD correctamente
- [ ] El timestamp se registra automáticamente
- [ ] El usuario_id se asigna correctamente
- [ ] La bandeja de mensajes filtra por usuario
- [ ] El filtro "Pendientes" muestra solo sin responder
- [ ] El filtro "Respondidos" muestra solo con respuesta
- [ ] Las respuestas se guardan y se muestran correctamente
- [ ] El estado cambia a "respondido" al responder
- [ ] Los timestamps se formatean correctamente en la UI
- [ ] Los colores de estado son correctos (amarillo/azul/verde)
- [ ] El botón de "Marcar en proceso" cambia el estado
- [ ] El cliente puede eliminar sus propios mensajes
- [ ] Las respuestas aparecen inmediatamente en el cliente

---

## Solución de Problemas Comunes

### "Error 404" en `/bandeja-mensajes`
- Verificar que la ruta está agregada en `App.jsx`
- Confirmar que el componente `BandejaMensajesSoporte.jsx` existe

### "No hay mensajes" en la bandeja
- Verificar que hay mensajes en la BD: `SELECT * FROM "mensajes";`
- Confirmar que el usuario está logueado
- Revisar console del navegador para errores

### "No puedo enviar respuesta"
- Verificar que el backend tiene la ruta PUT `/api/mensajes/:id`
- Confirmar que el mensaje_id es válido
- Revisar que el campo `respuesta` se está enviando en el body

### Los mensajes viejos no desaparecen
- Refrescar la página (Ctrl+F5)
- Verificar que el filtro está correcto
- Revisar la BD directamente

---

## Logs Útiles para Debug

En el backend (`server.js`), agregar logs:
```javascript
// routes/mensajes.js
router.post('/', async (req, res) => {
  console.log('📧 POST /mensajes:', req.body); // Log del request
  // ... resto del código
});

router.put('/:id', async (req, res) => {
  console.log('📧 PUT /mensajes/:id:', req.params.id, req.body);
  // ... resto del código
});
```

En el frontend (console del navegador):
```javascript
// Ver mensajes en localStorage
console.log(JSON.parse(localStorage.getItem('user')));

// Ver si la API está disponible
fetch('http://localhost:5000/api/mensajes')
  .then(r => r.json())
  .then(data => console.log('Mensajes:', data));
```

---

## Notas de Desarrollo

- El componente `BandejaMensajesSoporte` auto-recarga cada 30 segundos
- Los mensajes se filtran por `usuario_id` en el cliente
- Para atención, se muestran todos los mensajes
- El estado se valida en el backend
- Los timestamps son en UTC

---

¡Listo! El sistema de mensajes está completamente implementado y funcional. 🎉
