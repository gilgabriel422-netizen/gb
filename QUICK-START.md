# 🚀 QUICK START - Sistema de Mensajes

## En 2 minutos

### Cliente
```
1. http://localhost:3000
2. Login como cliente
3. Ir a: /enviar-atencion
4. Enviar mensaje
5. ✓ Listo
```

### Atención
```
1. http://localhost:3000/admin-login
2. Login como atencion@crm.com
3. Ir a: /dashboard-atencion
4. Click: "📧 Bandeja de Mensajes"
5. Responder mensaje
6. ✓ Listo
```

---

## URLs Principales

| Rol | URL |
|-----|-----|
| Cliente | http://localhost:3000/enviar-atencion |
| Atención | http://localhost:3000/bandeja-mensajes |
| Admin | http://localhost:3000/bandeja-mensajes |

---

## API Endpoints

```
GET    /api/mensajes              → Todos los mensajes
POST   /api/mensajes              → Crear mensaje
PUT    /api/mensajes/:id          → Responder
DELETE /api/mensajes/:id          → Eliminar
```

---

## Estados del Mensaje

- 🟡 **Pendiente** - Sin leer aún
- 🔵 **En proceso** - Siendo atendido
- 🟢 **Respondido** - Tiene respuesta

---

## Archivos Clave

```
frontend/src/pages/
├─ EnviarAtencion.jsx           ← Cliente
└─ BandejaMensajesSoporte.jsx   ← Atención

backend/
├─ models/Mensaje.js
└─ routes/mensajes.js
```

---

## Documentación

- [SISTEMA-MENSAJES.md](innovationbussines/SISTEMA-MENSAJES.md) - Técnica
- [TESTING-MENSAJES.md](innovationbussines/TESTING-MENSAJES.md) - Pruebas
- [README-MENSAJES.md](README-MENSAJES.md) - Resumen

---

## ¿Problemas?

1. ¿No se envía el mensaje?
   → Verifica POST /api/mensajes en Network tab

2. ¿No ves mensajes?
   → Verifica GET /api/mensajes en Network tab

3. ¿No se guarda respuesta?
   → Verifica PUT /api/mensajes/:id en Network tab

---

## Campo de Mensaje

```json
{
  "asunto": "Tema de la consulta",
  "contenido": "Descripción detallada",
  "usuario_id": 123,
  "tipo_remitente": "cliente",
  "estado": "pendiente"
}
```

---

¡Sistema listo! 🎉
