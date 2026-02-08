# 🎁 Sistema de Consumo de Beneficios del Cliente

## 📋 Descripción General

Sistema completo para gestionar beneficios de clientes, permitiendo:
- ✅ Crear beneficios personalizados por cliente
- ✅ Consumir beneficios con aprobación de administrador
- ✅ Rastrear historial de consumos
- ✅ Controlar saldos disponibles
- ✅ Manejar vencimientos de beneficios

---

## 🏗️ Estructura Técnica

### Base de Datos

#### Tabla: `beneficios`
```sql
CREATE TABLE beneficios (
  id SERIAL PRIMARY KEY,
  cliente_id INTEGER NOT NULL,
  tipo VARCHAR(50),                    -- puntos, descuento, cortesia, noche_gratis, upgrade, otro
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT,
  valor DECIMAL(10, 2) NOT NULL,       -- Valor total del beneficio
  saldo_disponible DECIMAL(10, 2),     -- Saldo aún no consumido
  fecha_vencimiento TIMESTAMP,
  activo BOOLEAN DEFAULT true,
  fecha_creacion TIMESTAMP,
  fecha_actualizacion TIMESTAMP,
  FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
```

#### Tabla: `consumo_beneficios`
```sql
CREATE TABLE consumo_beneficios (
  id SERIAL PRIMARY KEY,
  beneficio_id INTEGER NOT NULL,
  cliente_id INTEGER NOT NULL,
  monto_consumido DECIMAL(10, 2) NOT NULL,
  descripcion TEXT,
  referencia VARCHAR(255),             -- Ref. a reserva, transacción, etc.
  estado VARCHAR(50),                  -- pendiente, confirmado, cancelado, rechazado
  aprobado_por INTEGER,                -- Usuario que aprobó
  fecha_creacion TIMESTAMP,
  fecha_confirmacion TIMESTAMP,
  FOREIGN KEY (beneficio_id) REFERENCES beneficios(id),
  FOREIGN KEY (cliente_id) REFERENCES clientes(id),
  FOREIGN KEY (aprobado_por) REFERENCES usuarios(id)
);
```

---

## 📡 Endpoints API

### Para Clientes

#### Obtener beneficios disponibles
```http
GET /api/beneficios/cliente/:cliente_id
Authorization: Bearer {token}

Response:
{
  "beneficios": [
    {
      "id": 1,
      "cliente_id": 5,
      "tipo": "puntos",
      "nombre": "Puntos de Compra",
      "descripcion": "30% del valor en puntos de compensación",
      "valor": 270450.89,
      "saldo_disponible": 270450.89,
      "fecha_vencimiento": "2026-12-31",
      "activo": true
    }
  ],
  "total": 1
}
```

#### Consumir un beneficio
```http
POST /api/beneficios/consumir
Authorization: Bearer {token}
Content-Type: application/json

{
  "beneficio_id": 1,
  "cliente_id": 5,
  "monto_consumido": 1000.00,
  "descripcion": "Consumo en reserva de hotel",
  "referencia": "RES-2026-001"
}

Response:
{
  "mensaje": "Consumo de beneficio registrado exitosamente",
  "consumo": {
    "id": 3,
    "beneficio_id": 1,
    "cliente_id": 5,
    "monto_consumido": 1000.00,
    "estado": "pendiente",
    "fecha_creacion": "2026-02-05T...",
    ...
  },
  "nuevo_saldo": 269450.89
}
```

#### Obtener historial de consumos
```http
GET /api/beneficios/historial/:cliente_id
Authorization: Bearer {token}

Response:
{
  "historial": [
    {
      "id": 3,
      "beneficio_id": 1,
      "beneficio_nombre": "Puntos de Compra",
      "monto_consumido": 1000.00,
      "descripcion": "Consumo en reserva",
      "referencia": "RES-2026-001",
      "estado": "confirmado",
      "fecha_creacion": "2026-02-05T10:30:00",
      "fecha_confirmacion": "2026-02-05T10:45:00"
    }
  ],
  "total": 1
}
```

---

### Para Administradores

#### Crear beneficio para cliente
```http
POST /api/beneficios
Authorization: Bearer {token}
Content-Type: application/json

{
  "cliente_id": 5,
  "tipo": "descuento",
  "nombre": "Descuento Especial 20%",
  "descripcion": "Descuento aplicable a próximas compras",
  "valor": 5000.00,
  "fecha_vencimiento": "2026-12-31"
}

Response:
{
  "mensaje": "Beneficio creado exitosamente",
  "beneficio": { ... }
}
```

#### Obtener consumos pendientes
```http
GET /api/beneficios/admin/pendientes
Authorization: Bearer {token}

Response:
{
  "pendientes": [
    {
      "id": 3,
      "cliente_id": 5,
      "first_name": "Juan",
      "last_name": "Pérez",
      "email": "juan@email.com",
      "beneficio_id": 1,
      "beneficio_nombre": "Puntos de Compra",
      "monto_consumido": 1000.00,
      "descripcion": "Consumo en reserva",
      "referencia": "RES-2026-001",
      "fecha_creacion": "2026-02-05T10:30:00"
    }
  ],
  "total": 1
}
```

#### Confirmar consumo
```http
PATCH /api/beneficios/consumo/:consumo_id/confirmar
Authorization: Bearer {token}
Content-Type: application/json

{
  "aprobado_por": 1
}

Response:
{
  "mensaje": "Consumo confirmado exitosamente",
  "consumo": { ... }
}
```

#### Rechazar consumo
```http
PATCH /api/beneficios/consumo/:consumo_id/rechazar
Authorization: Bearer {token}

Response:
{
  "mensaje": "Consumo rechazado y saldo revertido",
  "consumo": { ... }
}
```

#### Actualizar saldo
```http
PATCH /api/beneficios/:beneficio_id/saldo
Authorization: Bearer {token}
Content-Type: application/json

{
  "saldo_disponible": 250000.00
}

Response:
{
  "mensaje": "Saldo actualizado exitosamente",
  "beneficio": { ... }
}
```

---

## 🖥️ Componentes Frontend

### BeneficiosCliente.jsx
**Ubicación**: `/frontend/src/components/BeneficiosCliente.jsx`

**Features**:
- Listar beneficios disponibles con saldos
- Visualizar progreso de consumo (progress bar)
- Consumir beneficios (genera solicitud pendiente)
- Ver historial de consumos con estados
- Validación de saldo y vencimiento

**Uso**:
```jsx
import BeneficiosCliente from '@/components/BeneficiosCliente';

<BeneficiosCliente clienteId={5} />
```

### BeneficiosAdmin.jsx
**Ubicación**: `/frontend/src/components/BeneficiosAdmin.jsx`

**Features**:
- Crear beneficios para clientes
- Gestionar beneficios existentes
- Aprobar/rechazar consumos pendientes
- Ver consumos con detalles del cliente
- Actualizar saldos

**Uso**:
```jsx
import BeneficiosAdmin from '@/components/BeneficiosAdmin';

<BeneficiosAdmin />
```

---

## 🚀 Instalación y Configuración

### 1. Crear tablas en BD

```bash
cd backend
node init-beneficios.js
```

Esto creará:
- Tabla `beneficios`
- Tabla `consumo_beneficios`
- Índices para optimización

### 2. Importar modelos en server.js

```javascript
const Beneficio = require('./models/Beneficio');
const ConsumoBeneficio = require('./models/ConsumoBeneficio');
```

✅ **Ya está hecho en la configuración**

### 3. Las rutas ya están registradas

```javascript
app.use('/api/beneficios', beneficiosRoutes);
```

✅ **Ya está incluido**

---

## 📊 Flujo de Consumo de Beneficios

```
┌─────────────────────────────────────────────────────┐
│ CLIENTE VE BENEFICIO DISPONIBLE                     │
│ Ej: 270,450.89 en puntos                            │
└──────────────┬──────────────────────────────────────┘
               │
               ├─► Hace clic en "Consumir"
               │
┌──────────────▼──────────────────────────────────────┐
│ CLIENTE INICIA SOLICITUD DE CONSUMO                 │
│ - Especifica monto (ej: $1,000)                     │
│ - Agrega descripción (opcional)                     │
│ - Sistema valida:                                   │
│   ✓ Saldo disponible >= monto                       │
│   ✓ Beneficio no vencido                            │
└──────────────┬──────────────────────────────────────┘
               │
               ├─► Estado: "pendiente"
               │   Saldo se RETIENE pero no se completa
               │
┌──────────────▼──────────────────────────────────────┐
│ ADMIN REVISA CONSUMOS PENDIENTES                    │
│ - Ve lista de solicitudes                           │
│ - Verifica cliente, monto, descripción              │
└──────────────┬──────────────────────────────────────┘
               │
        ┌──────┴──────┐
        │             │
        ▼             ▼
    CONFIRMAR     RECHAZAR
        │             │
        │             └─► Saldo se REVIERTE
        │                 Estado: "rechazado"
        │
        └─► Estado: "confirmado"
            Saldo se DESCUENTA
            fecha_confirmacion se registra
```

---

## 💰 Ejemplo de Caso de Uso

### Cliente "Juan Pérez" con Puntos

**Inicial**:
- Beneficio: "Puntos de Compra"
- Valor Total: $270,450.89
- Saldo Disponible: $270,450.89

**Consumo 1**:
- Juan intenta consumir $1,000
- Sistema crea `consumo_beneficios` con estado "pendiente"
- Saldo sigue siendo $270,450.89 (retenido)

**Admin Confirma**:
- Admin ve "1 consumo pendiente"
- Verifica y hace clic "Confirmar"
- Sistema actualiza saldo a $269,450.89
- Estado cambia a "confirmado"
- Juan ve en historial: "$1,000 - confirmado"

**Admin Rechaza (Escenario Alternativo)**:
- Si se rechaza, saldo vuelve a $270,450.89
- Estado: "rechazado"

---

## ⚙️ Configuración Avanzada

### Tipos de Beneficios

```javascript
const tipos = [
  'puntos',         // Sistema de puntos
  'descuento',      // Porcentaje/monto descuento
  'cortesia',       // Cortesías (comidas, etc.)
  'noche_gratis',   // Noches de hotel gratis
  'upgrade',        // Upgrades de servicios
  'otro'            // Tipo personalizado
];
```

### Estados de Consumo

```javascript
const estados = [
  'pendiente',      // Esperando aprobación
  'confirmado',     // Aprobado y aplicado
  'cancelado',      // Cancelado por sistema
  'rechazado'       // Rechazado por admin
];
```

---

## 🔒 Seguridad

- ✅ Todos los endpoints requieren autenticación JWT
- ✅ Validación de pertenencia (cliente_id en token)
- ✅ Saldos se descuentan solo si estado es "confirmado"
- ✅ Reversión automática de saldo en rechazo
- ✅ Auditoría: quién aprobó y cuándo

---

## 📈 Métricas y Reportes

Puedes generar reportes con:
- Total de beneficios por cliente
- Saldos disponibles vs. consumidos
- Consumos por período
- Tasa de aprobación/rechazo
- Beneficios próximos a vencer

---

## 🛠️ Troubleshooting

### Error: "Saldo insuficiente"
- Cliente intentó consumir más que saldo disponible
- Verificar en BeneficiosCliente el saldo mostrado

### Error: "Beneficio vencido"
- Beneficio pasó fecha_vencimiento
- Admin debe actualizar fecha o crear uno nuevo

### Error: "Beneficio no encontrado"
- Beneficio no existe o está inactivo
- Verificar ID y estado "activo"

---

## 📚 Archivos Creados/Modificados

### Nuevos:
- ✅ `backend/models/Beneficio.js`
- ✅ `backend/models/ConsumoBeneficio.js`
- ✅ `backend/controllers/beneficiosController.js`
- ✅ `backend/routes/beneficios.js`
- ✅ `backend/init-beneficios.js`
- ✅ `frontend/src/components/BeneficiosCliente.jsx`
- ✅ `frontend/src/components/BeneficiosAdmin.jsx`

### Modificados:
- ✅ `backend/server.js` (import + app.use)

---

## 🎯 Próximas Mejoras

- [ ] Sistema de puntos automático (% de compra)
- [ ] Notificaciones cuando vencimiento próximo
- [ ] Descuentos automáticos en checkout
- [ ] Integración con reservas para aplicar descuentos
- [ ] Dashboard de análisis de beneficios
- [ ] Exportar historial a PDF

---

**Desarrollado**: Febrero 2026
**Versión**: 1.0.0
**Estado**: ✅ Completamente Funcional
