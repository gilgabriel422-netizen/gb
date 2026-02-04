#!/bin/bash
# Script de verificación del Sistema de Mensajes

echo "================================"
echo "✓ Verificación del Sistema de Mensajes"
echo "================================"
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1"
        return 1
    fi
}

check_folder() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 (carpeta)"
        return 0
    else
        echo -e "${RED}✗${NC} $1 (carpeta)"
        return 1
    fi
}

echo "📄 Verificando Archivos Frontend..."
check_file "innovationbussines/frontend/src/pages/EnviarAtencion.jsx"
check_file "innovationbussines/frontend/src/pages/BandejaMensajesSoporte.jsx"
echo ""

echo "📄 Verificando Archivos Backend..."
check_file "innovationbussines/backend/models/Mensaje.js"
check_file "innovationbussines/backend/routes/mensajes.js"
echo ""

echo "📄 Verificando Archivos de Documentación..."
check_file "innovationbussines/SISTEMA-MENSAJES.md"
check_file "innovationbussines/TESTING-MENSAJES.md"
check_file "innovationbussines/IMPLEMENTACION-MENSAJES.md"
check_file "README-MENSAJES.md"
echo ""

echo "🔧 Verificando Rutas en App.jsx..."
if grep -q "BandejaMensajesSoporte" "innovationbussines/frontend/src/App.jsx"; then
    echo -e "${GREEN}✓${NC} BandejaMensajesSoporte importado en App.jsx"
else
    echo -e "${RED}✗${NC} BandejaMensajesSoporte NO importado en App.jsx"
fi

if grep -q "/bandeja-mensajes" "innovationbussines/frontend/src/App.jsx"; then
    echo -e "${GREEN}✓${NC} Ruta /bandeja-mensajes en App.jsx"
else
    echo -e "${RED}✗${NC} Ruta /bandeja-mensajes NO en App.jsx"
fi
echo ""

echo "🔧 Verificando DashboardAtencionCliente.jsx..."
if grep -q "bandeja-mensajes" "innovationbussines/frontend/src/pages/DashboardAtencionCliente.jsx"; then
    echo -e "${GREEN}✓${NC} Botón de bandeja agregado"
else
    echo -e "${RED}✗${NC} Botón de bandeja NO agregado"
fi
echo ""

echo "================================"
echo "📊 RESUMEN"
echo "================================"
echo ""
echo "Si ves todos los ✓, el sistema está listo:"
echo ""
echo "1. Frontend:"
echo "   - EnviarAtencion.jsx (para clientes)"
echo "   - BandejaMensajesSoporte.jsx (para atención)"
echo "   - Rutas en App.jsx"
echo ""
echo "2. Backend:"
echo "   - Modelo Mensaje.js (Sequelize)"
echo "   - Rutas API /api/mensajes"
echo ""
echo "3. Documentación:"
echo "   - SISTEMA-MENSAJES.md (referencia)"
echo "   - TESTING-MENSAJES.md (pruebas)"
echo "   - README-MENSAJES.md (resumen)"
echo ""
echo "================================"
echo "🚀 Para probar:"
echo "================================"
echo ""
echo "1. Abre: http://localhost:3000"
echo "2. Login como cliente"
echo "3. Ve a: /enviar-atencion"
echo "4. Envía un mensaje de prueba"
echo "5. Login como atención"
echo "6. Ve a: /bandeja-mensajes"
echo "7. Responde el mensaje"
echo ""
echo "================================"
