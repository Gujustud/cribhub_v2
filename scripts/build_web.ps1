# Build Flutter web for deploy: refresh git info, then build with production URLs.
# Run from repo root: .\scripts\build_web.ps1
$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = if ($scriptDir) { Split-Path -Parent $scriptDir } else { Get-Location }
if (-not (Test-Path (Join-Path $repoRoot '.git'))) { $repoRoot = Get-Location }
Set-Location $repoRoot

& (Join-Path $repoRoot 'scripts\update_git_info.ps1')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter build web `
  --dart-define=POCKETBASE_URL=https://cribhub.sscadcam.com/ `
  --dart-define=MCP_URL=https://cribhub.sscadcam.com/mcp
