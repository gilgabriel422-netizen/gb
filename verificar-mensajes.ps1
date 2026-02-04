# Script de verificación del Sistema de Mensajes (Windows PowerShell)

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Verificacion del Sistema de Mensajes" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

function Check-File {
    param([string]$path)
    if (Test-Path $path -PathType Leaf) {
        Write-Host "✓ $path" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "✗ $path" -ForegroundColor Red
        return $false
    }
}

function Check-Folder {
    param([string]$path)
    if (Test-Path $path -PathType Container) {
        Write-Host "✓ $path (carpeta)" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "✗ $path (carpeta)" -ForegroundColor Red
        return $false
    }
}

Write-Host "04 Verificando Archivos Frontend..." -ForegroundColor Yellow
Check-File "innovationbussines\frontend\src\pages\EnviarAtencion.jsx"
Check-File "innovationbussines\frontend\src\pages\BandejaMensajesSoporte.jsx"
Write-Host ""

Write-Host "04 Verificando Archivos Backend..." -ForegroundColor Yellow
Check-File "innovationbussines\backend\models\Mensaje.js"
Check-File "innovationbussines\backend\routes\mensajes.js"
Write-Host ""

Write-Host "04 Verificando Archivos de Documentacion..." -ForegroundColor Yellow
Check-File "innovationbussines\SISTEMA-MENSAJES.md"
Check-File "innovationbussines\TESTING-MENSAJES.md"
Check-File "innovationbussines\IMPLEMENTACION-MENSAJES.md"
Check-File "README-MENSAJES.md"
Write-Host ""

Write-Host "🔧 Verificando Rutas en App.jsx..." -ForegroundColor Yellow
$appContent = Get-Content "innovationbussines\frontend\src\App.jsx" -Raw

if ($appContent -match "BandejaMensajesSoporte") {
    Write-Host "✓ BandejaMensajesSoporte importado en App.jsx" -ForegroundColor Green
}
else {
    Write-Host "✗ BandejaMensajesSoporte NO importado en App.jsx" -ForegroundColor Red
}

if ($appContent -match "/bandeja-mensajes") {
    Write-Host "✓ Ruta /bandeja-mensajes en App.jsx" -ForegroundColor Green
}
else {
    Write-Host "✗ Ruta /bandeja-mensajes NO en App.jsx" -ForegroundColor Red
}
Write-Host ""

Write-Host "🔧 Verificando DashboardAtencionCliente.jsx..." -ForegroundColor Yellow
$dashContent = Get-Content "innovationbussines\frontend\src\pages\DashboardAtencionCliente.jsx" -Raw

if ($dashContent -match "bandeja-mensajes") {
    Write-Host "✓ Boton de bandeja agregado" -ForegroundColor Green
}
else {
    Write-Host "✗ Boton de bandeja NO agregado" -ForegroundColor Red
}
Write-Host ""

Write-Host "================================" -ForegroundColor Cyan
Write-Host "📊 RESUMEN" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Si ves todos los checkmarks, el sistema esta listo:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Frontend:" -ForegroundColor White
Write-Host "   - EnviarAtencion.jsx (para clientes)" -ForegroundColor Gray
Write-Host "   - BandejaMensajesSoporte.jsx (para atencion)" -ForegroundColor Gray
Write-Host "   - Rutas en App.jsx" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Backend:" -ForegroundColor White
Write-Host "   - Modelo Mensaje.js (Sequelize)" -ForegroundColor Gray
Write-Host "   - Rutas API /api/mensajes" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Documentacion:" -ForegroundColor White
Write-Host "   - SISTEMA-MENSAJES.md (referencia)" -ForegroundColor Gray
Write-Host "   - TESTING-MENSAJES.md (pruebas)" -ForegroundColor Gray
Write-Host "   - README-MENSAJES.md (resumen)" -ForegroundColor Gray
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "🚀 Para probar:" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Abre: http://localhost:3000" -ForegroundColor Cyan
Write-Host "2. Login como cliente" -ForegroundColor Cyan
Write-Host "3. Ve a: /enviar-atencion" -ForegroundColor Cyan
Write-Host "4. Envia un mensaje de prueba" -ForegroundColor Cyan
Write-Host "5. Login como atencion" -ForegroundColor Cyan
Write-Host "6. Ve a: /bandeja-mensajes" -ForegroundColor Cyan
Write-Host "7. Responde el mensaje" -ForegroundColor Cyan
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
