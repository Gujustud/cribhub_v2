# Build Flutter web for erp-dev (Proxmox LXC): refresh git info, build with dev URLs,
# verify the bundle points at the right PocketBase, then create deploy\erp-dev-web.zip.
# Run from repo root: .\scripts\build_web_erp_dev.ps1
#
# Defaults: PocketBase http://192.168.20.104:8091/ ; MCP http://192.168.20.104/mcp
# Override without editing this file:
#   $env:CRIBHUB_ERP_POCKETBASE_URL = 'http://erp-dev.sscadcam.com:8091/'
#   $env:CRIBHUB_ERP_MCP_URL = 'http://erp-dev.sscadcam.com/mcp'
$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = if ($scriptDir) { Split-Path -Parent $scriptDir } else { Get-Location }
if (-not (Test-Path (Join-Path $repoRoot '.git'))) { $repoRoot = Get-Location }
Set-Location $repoRoot

$pocketBaseUrl = if ($env:CRIBHUB_ERP_POCKETBASE_URL) { $env:CRIBHUB_ERP_POCKETBASE_URL } else { 'http://192.168.20.104:8091/' }
$mcpUrl = if ($env:CRIBHUB_ERP_MCP_URL) { $env:CRIBHUB_ERP_MCP_URL } else { 'http://192.168.20.104/mcp' }

Write-Host ""
Write-Host "=== erp-dev web build ===" -ForegroundColor Cyan
Write-Host "POCKETBASE_URL = $pocketBaseUrl"
Write-Host "MCP_URL          = $mcpUrl"
Write-Host ""

& (Join-Path $repoRoot 'scripts\update_git_info.ps1')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter build web `
  --dart-define=POCKETBASE_URL=$pocketBaseUrl `
  --dart-define=MCP_URL=$mcpUrl
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$webOut = Join-Path $repoRoot 'build\web'
$mainJs = Join-Path $webOut 'main.dart.js'
$indexHtml = Join-Path $webOut 'index.html'
$bootstrap = Join-Path $webOut 'flutter_bootstrap.js'

foreach ($p in @($indexHtml, $mainJs, $bootstrap)) {
  if (-not (Test-Path -LiteralPath $p)) {
    Write-Error "Missing after build: $p"
    exit 1
  }
}

$mainLen = (Get-Item -LiteralPath $mainJs).Length
if ($mainLen -lt 524288) {
  Write-Error "main.dart.js too small ($mainLen bytes). Build likely failed or output wrong."
  exit 1
}

# Stale LAN IP from pre-VLAN erp-dev - must not appear in the compiled bundle.
$staleFragments = @(
  '192.168.1.90:8091',
  '192.168.1.90'
)
foreach ($frag in $staleFragments) {
  if (Select-String -LiteralPath $mainJs -Pattern $frag -SimpleMatch -Quiet) {
    Write-Error "main.dart.js still contains stale PocketBase fragment '$frag'. Re-run with correct CRIBHUB_ERP_* env or defaults."
    exit 1
  }
}

# PocketBase host from URL must appear in the bundle (dart-define is compiled in).
try {
  $pbUri = [Uri]$pocketBaseUrl
  $pbHost = $pbUri.Host
  if ([string]::IsNullOrWhiteSpace($pbHost)) {
    Write-Error "Could not parse host from POCKETBASE_URL: $pocketBaseUrl"
    exit 1
  }
  if (-not (Select-String -LiteralPath $mainJs -Pattern $pbHost -SimpleMatch -Quiet)) {
    Write-Error "main.dart.js does not contain expected PocketBase host '$pbHost'. dart-define may not have been applied; check flutter output."
    exit 1
  }
}
catch {
  Write-Error "Invalid POCKETBASE_URL for validation: $pocketBaseUrl - $($_.Exception.Message)"
  exit 1
}

Write-Host "Bundle check OK: main.dart.js contains host '$pbHost' and no stale 192.168.1.90." -ForegroundColor Green

# --- Zip for deploy (same layout rules as production: archive root = contents of build\web)
$deployDir = Join-Path $repoRoot 'deploy'
$zipPath = Join-Path $deployDir 'erp-dev-web.zip'
New-Item -ItemType Directory -Path $deployDir -Force | Out-Null
if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force }

$zipOk = $false
$tarCmd = Get-Command tar -ErrorAction SilentlyContinue
if ($null -ne $tarCmd) {
  $tmpZip = Join-Path $deployDir 'erp-dev-web_tmp.zip'
  if (Test-Path -LiteralPath $tmpZip) { Remove-Item -LiteralPath $tmpZip -Force }
  Write-Host "Creating zip with tar..." -ForegroundColor Cyan
  & tar -a -c -f $tmpZip -C $webOut .
  if ($LASTEXITCODE -eq 0) {
    Move-Item -LiteralPath $tmpZip -Destination $zipPath -Force
    $zipOk = $true
  }
}

if (-not $zipOk) {
  Write-Host 'tar unavailable or failed; falling back to Compress-Archive.' -ForegroundColor Yellow
  Compress-Archive -Path (Join-Path $webOut '*') -DestinationPath $zipPath -Force
}

& (Join-Path $repoRoot 'scripts\validate_deploy_zip.ps1') -ZipPath $zipPath
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ""
Write-Host "Done. Output:" -ForegroundColor Green
Write-Host "  Web: $webOut"
Write-Host "  Zip: $zipPath"
Write-Host ""
Write-Host "Deploy on CT: empty /opt/pocketbase-erp-dev/pb_public then unzip -o $zipPath -d /opt/pocketbase-erp-dev/pb_public/"
Write-Host 'Browser: clear site data for the origin, then hard refresh (Flutter service worker caches old main.dart.js).'
Write-Host ""
