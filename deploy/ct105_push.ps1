# Push live shop web + purchases.currency migration to CT 105.
# Run in YOUR PowerShell (password prompt). From repo root or deploy/:
#   .\deploy\ct105_push.ps1
$ErrorActionPreference = 'Stop'
$ct = 'root@192.168.20.101'
$zip = 'C:\cribhub\deploy\shop-web.zip'
$mig = 'C:\cribhub\pb_migrations\1775700000_purchases_currency.js'
if (-not (Test-Path -LiteralPath $zip)) { throw "Missing $zip — run .\scripts\build_web_shop.ps1 first" }
if (-not (Test-Path -LiteralPath $mig)) { throw "Missing $mig" }

Write-Host "Copying shop-web.zip + currency migration..." -ForegroundColor Cyan
scp $zip "${ct}:/root/"
scp $mig "${ct}:/opt/pocketbase-erp-dev/pb_migrations/"

Write-Host "Installing web + restarting PocketBase..." -ForegroundColor Cyan
ssh $ct @'
rm -rf /opt/pocketbase-erp-dev/pb_public/* && unzip -o /root/shop-web.zip -d /opt/pocketbase-erp-dev/pb_public/ && ls /opt/pocketbase-erp-dev/pb_public/index.html /opt/pocketbase-erp-dev/pb_public/main.dart.js && systemctl restart pocketbase-erp-dev && sleep 2 && systemctl is-active pocketbase-erp-dev && curl -sS http://127.0.0.1:8091/api/health
'@

Write-Host ""
Write-Host "Done. Hard-refresh https://dharmacore.sscadcam.com/ (or clear site data)." -ForegroundColor Green
