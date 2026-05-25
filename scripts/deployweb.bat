@echo off
setlocal EnableExtensions

REM Laptop web deploy: production build, zip, validate, serve dist.zip (see DEPLOY.md).
REM Hardened: preflight build outputs, prefer tar zip, validate archive, print SHA256.

set "REPO_ROOT=%~dp0.."
pushd "%REPO_ROOT%" >nul

echo.
echo === Step 1: Production web build ===
powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\build_web.ps1"
if errorlevel 1 (
  echo.
  echo Build failed. Exiting.
  popd >nul
  exit /b 1
)

echo.
echo === Step 1b: Verify build\web output ===
if not exist "build\web\index.html" (
  echo ERROR: build\web\index.html missing after build.
  popd >nul
  exit /b 1
)
if not exist "build\web\main.dart.js" (
  echo ERROR: build\web\main.dart.js missing after build.
  popd >nul
  exit /b 1
)
if not exist "build\web\flutter_bootstrap.js" (
  echo ERROR: build\web\flutter_bootstrap.js missing after build.
  popd >nul
  exit /b 1
)

powershell -NoProfile -Command "$p='build\\web\\main.dart.js'; $n=(Get-Item -LiteralPath $p).Length; if ($n -lt 524288) { Write-Host ('ERROR: main.dart.js too small: ' + $n + ' bytes'); exit 1 }"
if errorlevel 1 (
  echo ERROR: main.dart.js must be at least 512 KB after build.
  popd >nul
  exit /b 1
)

echo.
echo === Step 2: Create deploy\dist.zip ===
if not exist "deploy" mkdir "deploy"
if exist "deploy\dist.zip" del /f /q "deploy\dist.zip"
REM Windows tar -a picks format from the OUTPUT FILE EXTENSION. A name like
REM dist.zip.part is NOT .zip, so tar may write a non-ZIP archive and validation fails.
if exist "deploy\dist_tmp.zip" del /f /q "deploy\dist_tmp.zip"

set "ZIP_OK=0"
where tar >nul 2>&1
if %errorlevel%==0 (
  echo Using tar to create zip ^(recommended for large Flutter web output^)...
  tar -a -c -f "deploy\dist_tmp.zip" -C "build\web" .
  if errorlevel 1 (
    echo ERROR: tar failed to create archive.
    popd >nul
    exit /b 1
  )
  move /y "deploy\dist_tmp.zip" "deploy\dist.zip" >nul
  set "ZIP_OK=1"
)

if "%ZIP_OK%"=="0" (
  echo tar not found or skipped; using Compress-Archive...
  powershell -NoProfile -Command "Compress-Archive -Path 'build\web\*' -DestinationPath 'deploy\dist.zip' -Force"
  if errorlevel 1 (
    echo ERROR: Compress-Archive failed.
    popd >nul
    exit /b 1
  )
)

echo.
echo === Step 2b: Validate dist.zip ===
powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\validate_deploy_zip.ps1" -ZipPath ".\deploy\dist.zip"
if errorlevel 1 (
  echo.
  echo Zip validation failed. Remove bad deploy\dist.zip and fix errors above.
  popd >nul
  exit /b 1
)

echo.
echo === Step 2c: SHA256 ^(compare on server after curl if desired^) ===
certutil -hashfile "deploy\dist.zip" SHA256 | findstr /v "^CertUtil"

echo.
echo === Step 3: Serve deploy folder on port 8888 ===
echo Use from server: curl -fLO http://^<YOUR_LAPTOP_IP^>:8888/dist.zip
echo Keep this window open while deploying. Press Ctrl+C to stop.

where python >nul 2>&1
if %errorlevel%==0 (
  cd /d "deploy"
  python -m http.server 8888
  popd >nul
  endlocal
  exit /b 0
)

where py >nul 2>&1
if %errorlevel%==0 (
  cd /d "deploy"
  py -3 -m http.server 8888
  popd >nul
  endlocal
  exit /b 0
)

echo ERROR: Neither python nor py launcher found on PATH.
popd >nul
endlocal
exit /b 1
