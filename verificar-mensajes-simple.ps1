Write-Host "================================"
Write-Host "Verificacion del Sistema de Mensajes"
Write-Host "================================"
Write-Host ""

Write-Host "Archivos Frontend:"
Get-ChildItem "innovationbussines\frontend\src\pages\EnviarAtencion.jsx" -ErrorAction SilentlyContinue | Write-Host -ForegroundColor Green
Get-ChildItem "innovationbussines\frontend\src\pages\BandejaMensajesSoporte.jsx" -ErrorAction SilentlyContinue | Write-Host -ForegroundColor Green

Write-Host ""
Write-Host "Archivos Backend:"
Get-ChildItem "innovationbussines\backend\models\Mensaje.js" -ErrorAction SilentlyContinue | Write-Host -ForegroundColor Green
Get-ChildItem "innovationbussines\backend\routes\mensajes.js" -ErrorAction SilentlyContinue | Write-Host -ForegroundColor Green

Write-Host ""
Write-Host "Documentacion:"
Get-ChildItem "innovationbussines\SISTEMA-MENSAJES.md" -ErrorAction SilentlyContinue | Write-Host -ForegroundColor Green
Get-ChildItem "innovationbussines\TESTING-MENSAJES.md" -ErrorAction SilentlyContinue | Write-Host -ForegroundColor Green
Get-ChildItem "README-MENSAJES.md" -ErrorAction SilentlyContinue | Write-Host -ForegroundColor Green

Write-Host ""
Write-Host "================================"
Write-Host "Listo para probar en: http://localhost:3000"
Write-Host "================================"
