# Deploy script - prepara arquivos para producao
param(
    [string]$OutputDir = "dist-deploy"
)

Write-Host "Iniciando build para producao..." -ForegroundColor Cyan

# Limpar pasta de output anterior
if (Test-Path $OutputDir) {
    Write-Host "Limpando pasta anterior..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $OutputDir
}

# Criar estrutura de pastas
Write-Host "Criando estrutura de pastas..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
New-Item -ItemType Directory -Force -Path "$OutputDir\dist" | Out-Null

# Build do CSS minificado
Write-Host "Compilando CSS para producao..." -ForegroundColor Green
& node ./scripts/build-css.js --minify

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao compilar CSS" -ForegroundColor Red
    exit 1
}

# Copiar arquivos necessarios
Write-Host "Copiando arquivos..." -ForegroundColor Green

# HTML
Copy-Item "site\index.html" "$OutputDir\" -Force

# CSS compilado
Copy-Item "site\dist\styles.css" "$OutputDir\dist\" -Force

# Imagens (todos os tipos)
Get-ChildItem "site" -File | Where-Object { $_.Extension -match '\.(jpg|jpeg|png|gif|svg|webp|ico)$' } | ForEach-Object {
    Copy-Item $_.FullName "$OutputDir\" -Force
    Write-Host "  Copiado: $($_.Name)" -ForegroundColor Gray
}

# Verificar tamanho total
$totalSize = (Get-ChildItem -Path $OutputDir -Recurse | Measure-Object -Property Length -Sum).Sum
$totalSizeMB = [math]::Round($totalSize / 1MB, 2)

Write-Host ""
Write-Host "Build concluido com sucesso!" -ForegroundColor Green
Write-Host "Pasta de deploy: $OutputDir" -ForegroundColor Cyan
Write-Host "Tamanho total: $totalSizeMB MB" -ForegroundColor Cyan
Write-Host ""
Write-Host "Arquivos prontos para upload:" -ForegroundColor Yellow
Get-ChildItem -Path $OutputDir -Recurse -File | ForEach-Object {
    $relativePath = $_.FullName.Substring((Get-Location).Path.Length + 1)
    Write-Host "  $relativePath" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Para testar localmente:" -ForegroundColor Cyan
Write-Host "  cd $OutputDir" -ForegroundColor White
Write-Host "  php -S localhost:8080" -ForegroundColor White
