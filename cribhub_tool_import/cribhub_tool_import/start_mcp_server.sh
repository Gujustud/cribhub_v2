#!/bin/bash
# CribHub MCP Server Startup Script for Linux/Mac

echo "========================================"
echo "CribHub Tool Import MCP Server"
echo "========================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed"
    echo "Please install Python 3.8+"
    exit 1
fi

# Check if Ollama is running
echo "Checking Ollama status..."
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "WARNING: Ollama doesn't seem to be running"
    echo "Please start Ollama first: ollama serve"
    echo ""
    read -p "Press Enter to continue anyway or Ctrl+C to exit..."
fi

# Check if requirements are installed
echo "Checking dependencies..."
python3 -c "import fastapi" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Installing dependencies..."
    pip3 install -r requirements.txt
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to install dependencies"
        exit 1
    fi
fi

echo ""
echo "Starting MCP Server on http://localhost:8001"
echo "Press Ctrl+C to stop"
echo ""

# Start the server
python3 mcp_server.py
