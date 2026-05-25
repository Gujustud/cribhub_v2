# Validates deploy\dist.zip before serving (layout, size, main.dart.js sanity).
# Exit 0 on success; non-zero on failure.
param(
  [Parameter(Mandatory = $true)]
  [string]$ZipPath,

  [long]$MinZipBytes = 1MB,

  [long]$MinMainDartBytes = 512KB
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $ZipPath)) {
  Write-Error "Zip not found: $ZipPath"
  exit 2
}

$item = Get-Item -LiteralPath $ZipPath
if ($item.Length -lt $MinZipBytes) {
  Write-Error "Zip too small ($($item.Length) bytes). Expected at least $MinZipBytes bytes. Build or archive likely failed."
  exit 3
}

function Normalize-ZipEntryName([string]$fullName) {
  if ([string]::IsNullOrWhiteSpace($fullName)) { return '' }
  $s = $fullName.Replace('\', '/').Trim()
  # Windows tar often stores names as "./index.html" instead of "index.html"
  while ($s.StartsWith('./')) { $s = $s.Substring(2) }
  $s = $s.TrimStart('/')
  while ($s.StartsWith('.\')) { $s = $s.Substring(2) }
  return $s.TrimEnd('/')
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
try {
  $zip = [System.IO.Compression.ZipFile]::OpenRead($item.FullName)
}
catch {
  Write-Error @"
Cannot open zip (file may be corrupt or not a real ZIP). Size: $($item.Length) bytes.

Common cause on Windows: ``tar -a`` chooses format from the OUTPUT filename extension.
The archive path must end in ``.zip`` (not ``.zip.part``). Re-run ``deployweb.bat`` or recreate the zip with a ``.zip`` temp name.

Inner error: $($_.Exception.Message)
"@
  exit 12
}

try {
  $entries = @($zip.Entries)
  if ($entries.Count -eq 0) {
    Write-Error 'Zip is empty.'
    exit 4
  }

  # Normalize paths (backslashes, leading ./ from Windows tar, trailing slashes)
  $names = $entries | ForEach-Object { Normalize-ZipEntryName $_.FullName } | Where-Object { $_ -ne '' }

  if ($names -contains 'web/index.html') {
    Write-Error "Wrong zip layout: found web/index.html. Zip must be built from build\web\* (contents), not the web folder itself."
    exit 5
  }

  if (-not ($names -contains 'index.html')) {
    $sample = ($names | Select-Object -First 12) -join ', '
    Write-Error "Zip must contain index.html at archive root. Found $($entries.Count) entries; first few: $sample"
    exit 6
  }

  if (-not ($names -contains 'main.dart.js')) {
    Write-Error 'Zip must contain main.dart.js at archive root.'
    exit 7
  }

  $mainEntry = $entries | Where-Object { (Normalize-ZipEntryName $_.FullName) -eq 'main.dart.js' } | Select-Object -First 1
  if ($null -eq $mainEntry) {
    Write-Error 'main.dart.js entry missing.'
    exit 8
  }

  if ($mainEntry.Length -lt $MinMainDartBytes) {
    Write-Error "main.dart.js in zip is too small ($($mainEntry.Length) bytes). Expected at least $MinMainDartBytes bytes."
    exit 9
  }

  $stream = $mainEntry.Open()
  try {
    $buf = New-Object byte[] 200
    $read = $stream.Read($buf, 0, $buf.Length)
    if ($read -lt 2) {
      Write-Error 'Could not read start of main.dart.js from zip.'
      exit 10
    }
    $prefix = [System.Text.Encoding]::UTF8.GetString($buf, 0, $read)
    if ($prefix -match '<!DOCTYPE|<html') {
      Write-Error 'main.dart.js in zip looks like HTML (wrong content). Do not use an error page as the bundle.'
      exit 11
    }
  }
  finally {
    if ($null -ne $stream) { $stream.Dispose() }
  }

  Write-Host "Zip OK: $($item.Length) bytes, $($entries.Count) entries, main.dart.js $($mainEntry.Length) bytes."
}
finally {
  $zip.Dispose()
}

exit 0
