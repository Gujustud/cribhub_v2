@echo off
REM CribHub MCP Server Startup Script for Windows

echo ========================================
echo CribHub Tool Import MCP Server
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8+ from python.org
    pause
    exit /b 1
)

REM Check if Ollama is running
echo Checking Ollama status...
curl -s http://localhost:11434/api/tags >nul 2>&1
if errorlevel 1 (
    echo WARNING: Ollama doesn't seem to be running
    echo Please start Ollama first
    echo.
    pause
)

REM Check if requirements are installed
echo Checking dependencies...
python -c "import fastapi" >nul 2>&1
if errorlevel 1 (
    echo Installing dependencies...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo ERROR: Failed to install dependencies
        pause
        exit /b 1
    )
)

echo.
echo Starting MCP Server on http://localhost:8001
echo Press Ctrl+C to stop
echo.

REM Start the server
python mcp_server.py

pause
