# 🎁 Guía Rápida: Sistema de Consumo de Beneficios

## ¿Qué es?

Sistema que permite a los clientes:
- Ver beneficios disponibles (puntos, descuentos, cortesías)
- Consumir beneficios (genera solicitud de aprobación)
- Verificar historial de consumos

Y permite a los administradores:
- Crear beneficios para cada cliente
- Aprobar/rechazar solicitudes de consumo
- Gestionar saldos

---

## 🚀 Uso Rápido

### Para Clientes

1. **Ver mis beneficios**
   - Component: `BeneficiosCliente`
   - Muestra todos los beneficios disponibles con saldos
   - Indica fecha de vencimiento si aplica

2. **Consumir un beneficio**
   - Clic en "Consumir" del beneficio
   - Especificar monto a consumir
   - Sistema valida saldo y vencimiento
   - Se genera solicitud (Estado: Pendiente)

3. **Ver historial**
   - Pestaña "Historial de Consumos"
   - Ve estado (Pendiente, Confirmado, Rechazado)
   - Fechas de creación y confirmación

### Para Administradores

1. **Crear beneficio**
   - Tab "Crear Beneficio"
   - Seleccionar cliente
   - Especificar tipo, nombre, valor
   - Establecer vencimiento (opcional)

2. **Aprobar consumos**
   - Tab "Consumos Pendientes"
   - Ve lista con cliente, monto, descripción
   - Clic "Confirmar" → saldo se descuenta
   - Clic "Rechazar" → saldo se revierte

3. **Gestionar beneficios**
   - Tab "Beneficios del Cliente"
   - Seleccionar cliente
   - Ver todos sus beneficios y saldos

---

## 📊 Datos de Ejemplo

Se poblaron automáticamente:
- 5 clientes con 5 beneficios cada uno
- Total: 25 beneficios

**Tipos de beneficios creados**:
- ⭐ Puntos: $270,450.89
- 💰 Descuento 15%: $5,000
- 🏨 Noche Gratis: $300
- 🎁 Cortesía Comidas: $200
- ⬆️ Upgrade: $150

---

## 🔌 Endpoints Principales

```bash
# Obtener beneficios de cliente
GET /api/beneficios/cliente/:cliente_id

# Consumir beneficio (cliente)
POST /api/beneficios/consumir

# Ver consumos pendientes (admin)
GET /api/beneficios/admin/pendientes

# Confirmar consumo (admin)
PATCH /api/beneficios/consumo/:consumo_id/confirmar

# Rechazar consumo (admin)
PATCH /api/beneficios/consumo/:consumo_id/rechazar

# Crear beneficio (admin)
POST /api/beneficios
```

---

## 📁 Archivos Importantes

```
backend/
  ├── models/
  │   ├── Beneficio.js              ← Modelo de beneficio
  │   └── ConsumoBeneficio.js        ← Modelo de consumo
  ├── controllers/
  │   └── beneficiosController.js    ← Lógica de negocio
  ├── routes/
  │   └── beneficios.js              ← Rutas API
  ├── init-beneficios.js             ← Crear tablas
  └── poblar-beneficios.js           ← Datos de ejemplo

frontend/src/components/
  ├── BeneficiosCliente.jsx          ← Vista para clientes
  └── BeneficiosAdmin.jsx            ← Vista para admins

BENEFICIOS_SISTEMA.md               ← Documentación completa
```

---

## ✅ Estados de Consumo

| Estado | Descripción | Saldo |
|--------|-------------|-------|
| **Pendiente** | Espera aprobación admin | Retenido |
| **Confirmado** | Aprobado, saldo descuento | Descuento |
| **Rechazado** | Rechazado, revierte saldo | Se devuelve |

---

## 🎯 Ejemplo de Flujo Completo

```
1. CLIENTE VE BENEFICIO
   "Puntos de Compra: $270,450.89 disponible"

2. CLIENTE CONSUME
   Genera solicitud: "Consumir $1,000"
   Estado: Pendiente
   Saldo: Retenido en $270,450.89

3. ADMIN REVISA
   Ve "1 consumo pendiente"
   Cliente: Juan Pérez
   Monto: $1,000
   Descripción: "Compra de hotel"

4. ADMIN CONFIRMA
   Clic "Confirmar"
   Saldo actualizado: $269,450.89
   Estado: Confirmado
   Juan ve en historial: "Confirmado - 05/02/2026"

   OU

   ADMIN RECHAZA
   Clic "Rechazar"
   Saldo vuelve: $270,450.89
   Estado: Rechazado
   Juan ve en historial: "Rechazado - 05/02/2026"
```

---

## 🔐 Seguridad

- ✅ JWT authentication en todos los endpoints
- ✅ Validación de saldo y vencimiento
- ✅ Saldo solo se descuenta con confirmación
- ✅ Reversión automática en rechazo
- ✅ Auditoría de quién aprobó y cuándo

---

## 📊 Integraciones Futuras

Próximas mejoras:
- ✨ Puntos automáticos por compra (30%)
- ✨ Aplicar descuentos automático en checkout
- ✨ Notificaciones de vencimiento
- ✨ Dashboard de análisis
- ✨ Exportar a PDF

---

**Versión**: 1.0.0
**Fecha**: Febrero 2026
**Estado**: ✅ Listo para Producción
