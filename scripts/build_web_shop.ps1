# Build Flutter web for live shop (CT 105 / dharmacore.sscadcam.com).
# Run from repo root: .\scripts\build_web_shop.ps1
#
# Override without editing:
#   $env:CRIBHUB_SHOP_POCKETBASE_URL = 'https://dharmacore.sscadcam.com/'
#   $env:CRIBHUB_SHOP_MCP_URL = 'https://dharmacore.sscadcam.com/mcp'
$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = if ($scriptDir) { Split-Path -Parent $scriptDir } else { Get-Location }
if (-not (Test-Path (Join-Path $repoRoot '.git'))) { $repoRoot = Get-Location }
Set-Location $repoRoot

$pocketBaseUrl = if ($env:CRIBHUB_SHOP_POCKETBASE_URL) { $env:CRIBHUB_SHOP_POCKETBASE_URL } else { 'https://dharmacore.sscadcam.com/' }
$mcpUrl = if ($env:CRIBHUB_SHOP_MCP_URL) { $env:CRIBHUB_SHOP_MCP_URL } else { 'https://dharmacore.sscadcam.com/mcp' }
$ctHost = '192.168.20.101'
$webRoot = '/opt/pocketbase-erp-dev/pb_public'

Write-Host ""
Write-Host "=== live shop web build (CT 105) ===" -ForegroundColor Cyan
Write-Host "POCKETBASE_URL = $pocketBaseUrl"
Write-Host "MCP_URL          = $mcpUrl"
Write-Host ""

& (Join-Path $repoRoot 'scripts\update_git_info.ps1')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter build web `
  --no-tree-shake-icons `
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

try {
  $pbUri = [Uri]$pocketBaseUrl
  $pbHost = $pbUri.Host
  if ([string]::IsNullOrWhiteSpace($pbHost)) {
    Write-Error "Could not parse host from POCKETBASE_URL: $pocketBaseUrl"
    exit 1
  }
  if (-not (Select-String -LiteralPath $mainJs -Pattern $pbHost -SimpleMatch -Quiet)) {
    Write-Error "main.dart.js does not contain expected PocketBase host '$pbHost'. dart-define may not have been applied."
    exit 1
  }
}
catch {
  Write-Error "Invalid POCKETBASE_URL for validation: $pocketBaseUrl - $($_.Exception.Message)"
  exit 1
}

Write-Host "Bundle check OK: main.dart.js contains host '$pbHost'." -ForegroundColor Green

$deployDir = Join-Path $repoRoot 'deploy'
$zipPath = Join-Path $deployDir 'shop-web.zip'
New-Item -ItemType Directory -Path $deployDir -Force | Out-Null
if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force }

$zipOk = $false
$tarCmd = Get-Command tar -ErrorAction SilentlyContinue
if ($null -ne $tarCmd) {
  $tmpZip = Join-Path $deployDir 'shop-web_tmp.zip'
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
Write-Host "=== Deploy (run in YOUR PowerShell; enter SSH password) ===" -ForegroundColor Cyan
Write-Host "scp $zipPath root@${ctHost}:/root/"
Write-Host "ssh root@$ctHost `"rm -rf $webRoot/* && unzip -o /root/shop-web.zip -d $webRoot/ && ls $webRoot/index.html $webRoot/main.dart.js`""
Write-Host ""
Write-Host "Then hard-refresh https://dharmacore.sscadcam.com/ (or clear site data)."
Write-Host "Full notes: DEPLOY_SHOP.md"
Write-Host ""
