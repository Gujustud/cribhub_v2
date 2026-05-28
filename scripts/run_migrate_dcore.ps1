# Run DharmaCore → erp-dev PocketBase migration from repo root.
$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$migrateDir = Join-Path $scriptDir 'migrate_dcore'
Set-Location $migrateDir

if (-not (Test-Path (Join-Path $migrateDir '.env'))) {
  Write-Host "Create scripts\migrate_dcore\.env from .env.example and set admin credentials." -ForegroundColor Yellow
  exit 1
}

if (-not (Test-Path (Join-Path $migrateDir 'node_modules'))) {
  Write-Host "npm install..." -ForegroundColor Cyan
  npm install
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

npm run migrate
exit $LASTEXITCODE
