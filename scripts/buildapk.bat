@echo off
setlocal

REM Build Android release APK with production backend URLs.
REM Prevents accidental localhost release builds.

set "REPO_ROOT=%~dp0.."
pushd "%REPO_ROOT%" >nul

echo.
echo === Building production APK ===
flutter build apk --release ^
  --dart-define=POCKETBASE_URL=https://cribhub.sscadcam.com/ ^
  --dart-define=MCP_URL=https://cribhub.sscadcam.com/mcp

if errorlevel 1 (
  echo.
  echo Production APK build failed.
  popd >nul
  exit /b 1
)

echo.
echo Build complete:
echo   build\app\outputs\flutter-apk\app-release.apk

popd >nul
endlocal
