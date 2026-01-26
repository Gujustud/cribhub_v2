# CribHub Auto Tool Import Feature

Automatically import tool specifications from vendor websites using AI (Qwen2.5 via Ollama).

## 🚀 Quick Start

### 1. Update PocketBase
Add `enable_tool_import` field (boolean, default: false) to `app_settings` collection.

### 2. Install MCP Server
```bash
# Install dependencies
pip install -r requirements.txt

# Start server
python mcp_server.py
```

### 3. Update Flutter App
- Add `tool_import_config_screen.dart` to `lib/`
- Update `settings_screen.dart` (use provided version)
- Update `pocketbase_service.dart` (add methods from `pocketbase_service_additions.dart`)
- Update `add_tool_screen.dart` (follow `add_tool_screen_additions.dart`)

### 4. Enable in App
Settings → Enable Auto Tool Import → ON

## 📁 Files Included

### Backend (Python)
- `mcp_server.py` - Main MCP server with Ollama integration
- `requirements.txt` - Python dependencies
- `start_mcp_server.bat` - Windows startup script
- `start_mcp_server.sh` - Linux/Mac startup script

### Frontend (Flutter/Dart)
- `settings_screen.dart` - Updated settings with import toggle
- `tool_import_config_screen.dart` - New config screen
- `pocketbase_service_additions.dart` - Methods to add to your service
- `add_tool_screen_additions.dart` - Changes needed in add tool screen

### Documentation
- `INSTALLATION_GUIDE.md` - Complete step-by-step installation guide

## 🎯 Features

- ✅ **Local AI** - No API costs, runs on Qwen2.5 via Ollama
- ✅ **Privacy** - All processing happens on your hardware
- ✅ **Safe** - Opt-in feature, disabled by default
- ✅ **Smart** - Extracts specs from messy HTML intelligently
- ✅ **Expandable** - Easy to add new vendors

## 🛠️ Supported Vendors

- **Harvey Tool** - Built-in support

To add more vendors, edit `VENDOR_URL_PATTERNS` in `mcp_server.py`.

## 💻 System Requirements

### Development (Your G14):
- ✅ Plenty of power for Qwen2.5 1.5B or 3B

### Production (Mini PC - Intel Celeron J4125, 8GB RAM):
- ✅ Qwen2.5 1.5B - Works well (~2GB RAM)
- ⚠️ Qwen2.5 3B - Tight but possible (~3GB RAM)
- ❌ Qwen2.5 8B+ - Not enough RAM

## 📊 Performance

| Model | RAM Usage | Speed | Accuracy |
|-------|-----------|-------|----------|
| Qwen2.5 1.5B | ~2GB | 3-5s | Good |
| Qwen2.5 3B | ~3GB | 5-10s | Better |

## 🔧 How It Works

```
Flutter App
    ↓ [User clicks Import]
PocketBase Service
    ↓ [HTTP Request]
MCP Server (Python/FastAPI)
    ↓ [Fetch webpage]
    ↓ [Send HTML to Ollama]
Ollama (Qwen2.5)
    ↓ [Extract structured data]
MCP Server
    ↓ [Return JSON]
Flutter App
    ↓ [Show preview, populate fields]
```

## 🧪 Testing

Test with Harvey Tool model **814193**:
1. Add Tool → Brand: Harvey Tool
2. Model Number: 814193
3. Click "Import" button
4. Should populate: diameter, flutes, flute length, etc.

## 🐛 Troubleshooting

### MCP Server won't start
- Check Python version: `python --version` (need 3.8+)
- Install deps: `pip install -r requirements.txt`

### Import fails
- Check Ollama is running: `ollama list`
- Check MCP server is running: http://localhost:8001
- Check model is loaded: `ollama list | grep qwen2.5`

### Wrong data extracted
- AI isn't perfect - always review before importing
- Try Qwen2.5 3B for better accuracy
- Adjust prompt in `mcp_server.py` for specific vendors

## 📝 Configuration

### Change MCP Server Port
```bash
# Linux/Mac
export PORT=9000
python3 mcp_server.py

# Windows (PowerShell)
$env:PORT=9000
python mcp_server.py
```

### Use Different Model
```bash
# Try 3B for better accuracy (needs ~3GB RAM)
export OLLAMA_MODEL=qwen2.5:3b
python3 mcp_server.py
```

### Change Server URL (if not localhost)
Edit these files:
- `pocketbase_service.dart` → `mcpServerUrl` constant
- `tool_import_config_screen.dart` → `_mcpServerUrl` field

## 🔐 Security Notes

- MCP server has no authentication (runs locally)
- If exposing to network, add API key authentication
- CORS is wide open by default (fine for local use)
- In production, restrict CORS to your PocketBase domain

## 📚 Full Documentation

See `INSTALLATION_GUIDE.md` for complete step-by-step instructions.

## 💰 Cost

**$0.00** - Everything is free and open source!

## 🎓 Learn More

- [Ollama Documentation](https://ollama.com)
- [Qwen2.5 Model Card](https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)

---

Built for CribHub - Making tool inventory management easier, one import at a time! 🔧
