# CribHub Tool Import Feature - Installation Guide

## Overview
This feature allows automatic import of tool specifications from vendor websites using a local LLM (Qwen2.5) via Ollama. It's completely opt-in and can be enabled/disabled in settings.

---

## Part 1: PocketBase Database Changes

### Add Field to `app_settings` Collection

1. Open PocketBase Admin UI (usually at http://127.0.0.1:8090/_/)
2. Go to Collections → `app_settings`
3. Click "Edit collection"
4. Click "+ New field"
5. Add the following field:
   - **Type:** Boolean
   - **Name:** `enable_tool_import`
   - **Default value:** `false` (unchecked)
6. Click "Save"

That's it for PocketBase! The feature is disabled by default and safe to deploy.

---

## Part 2: MCP Server Setup (Python)

### Prerequisites
- Python 3.8+ installed
- Ollama installed with Qwen2.5 model (you already have this!)

### Installation Steps

1. **Create a folder for the MCP server** (can be anywhere):
   ```bash
   mkdir ~/cribhub-mcp-server
   cd ~/cribhub-mcp-server
   ```

2. **Copy the MCP server files**:
   - Copy `mcp_server.py` to this folder
   - Copy `requirements.txt` to this folder

3. **Install Python dependencies**:
   ```bash
   # On Windows (PowerShell or CMD):
   pip install -r requirements.txt

   # On Linux/Mac:
   pip3 install -r requirements.txt
   ```

4. **Test the MCP server**:
   ```bash
   # On Windows:
   python mcp_server.py

   # On Linux/Mac:
   python3 mcp_server.py
   ```

   You should see:
   ```
   INFO:     Started server process
   INFO:     Uvicorn running on http://0.0.0.0:8001
   ```

5. **Test if it's working**:
   - Open browser to http://localhost:8001
   - You should see: `{"status":"online","service":"CribHub Tool Import MCP Server",...}`

6. **Make sure Ollama is running** with Qwen2.5:
   ```bash
   ollama list
   # Should show qwen2.5:1.5b
   ```

---

## Part 3: Flutter App Updates

### Files to Update/Add

#### 1. **Add new file:** `lib/tool_import_config_screen.dart`
   - Copy the entire `tool_import_config_screen.dart` file to your `lib/` folder

#### 2. **Update:** `lib/settings_screen.dart`
   - Replace your current `settings_screen.dart` with the new version
   - This adds the "Enable Auto Tool Import" toggle and config screen link

#### 3. **Update:** `lib/pocketbase_service.dart`
   - Open `pocketbase_service_additions.dart`
   - Copy the two methods shown and add them to your `pocketbase_service.dart`:
     - Update `updateAppSettings()` to include `enableToolImport` parameter
     - Add new `importToolSpecs()` method
   - Make sure you have these imports at the top:
     ```dart
     import 'package:http/http.dart' as http;
     import 'dart:convert';
     ```

#### 4. **Update:** `lib/add_tool_screen.dart`
   - Open `add_tool_screen_additions.dart`
   - Follow the numbered instructions to add:
     - State variables (step 1)
     - Updated `_loadSettings()` (step 2)
     - New import methods (steps 3-6)
     - Updated Model Number field with Import button (step 7)

---

## Part 4: Running Everything

### Development Setup (Your G14 Laptop)

1. **Start Ollama** (if not already running as a service):
   ```bash
   # Usually starts automatically, but if needed:
   ollama serve
   ```

2. **Start the MCP Server** in a terminal:
   ```bash
   cd ~/cribhub-mcp-server
   python mcp_server.py
   ```
   Leave this running.

3. **Start PocketBase** in another terminal:
   ```bash
   cd /path/to/your/pocketbase
   ./pocketbase serve
   ```

4. **Start your Flutter app**:
   ```bash
   cd /path/to/cribhub
   flutter run
   ```

### Production Setup (Mini PC at Shop)

#### Option A: Run MCP Server Manually
1. SSH into your mini PC
2. Start the MCP server:
   ```bash
   cd ~/cribhub-mcp-server
   python3 mcp_server.py
   ```

#### Option B: Run MCP Server as a Service (Recommended)

Create a systemd service file on your mini PC:

1. Create `/etc/systemd/system/cribhub-mcp.service`:
   ```ini
   [Unit]
   Description=CribHub MCP Tool Import Server
   After=network.target

   [Service]
   Type=simple
   User=YOUR_USERNAME
   WorkingDirectory=/home/YOUR_USERNAME/cribhub-mcp-server
   ExecStart=/usr/bin/python3 /home/YOUR_USERNAME/cribhub-mcp-server/mcp_server.py
   Restart=always
   RestartSec=10

   [Install]
   WantedBy=multi-user.target
   ```

2. Enable and start the service:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable cribhub-mcp.service
   sudo systemctl start cribhub-mcp.service
   sudo systemctl status cribhub-mcp.service
   ```

---

## Part 5: Testing the Feature

1. **Enable the feature**:
   - Open CribHub app
   - Go to Settings
   - Turn ON "Enable Auto Tool Import"
   - (Optional) Click "Configure Tool Import" to check server status

2. **Test importing a tool**:
   - Click "Add Tool"
   - Select **Brand:** "Harvey Tool" (or "Harvey")
   - Enter **Model Number:** `814193`
   - Click the **"Import"** button next to Model Number
   - Wait 5-10 seconds (Qwen2.5 is processing)
   - Review the preview dialog
   - Click "Import" to populate fields

3. **Verify the data**:
   - Check that diameter, flutes, flute length, etc. are populated
   - Save the tool normally

---

## Troubleshooting

### "MCP Server is offline" in Config Screen
- Make sure `mcp_server.py` is running
- Check the URL: default is `http://localhost:8001`
- If running on mini PC, you may need to change the URL in `tool_import_config_screen.dart`

### "Failed to connect to import server"
- Check firewall settings
- Make sure port 8001 is not blocked
- Try accessing http://localhost:8001 in a browser

### "Ollama API error"
- Make sure Ollama is running: `ollama list`
- Check if Qwen2.5 is installed: should show `qwen2.5:1.5b`
- Check Ollama logs

### Import takes too long
- First import is slower (model loading)
- Subsequent imports are faster (~3-5 seconds)
- Consider using Qwen2.5 3B for better accuracy (but slower)

### Extracted data is incorrect
- The LLM does its best but isn't perfect
- Always review the preview before importing
- You can manually edit after import
- Consider improving the prompt in `mcp_server.py`

---

## Configuration Options

### Change MCP Server Port
In `mcp_server.py`, change the last line:
```python
port = int(os.getenv("PORT", "8001"))  # Change 8001 to your port
```

Or set environment variable:
```bash
export PORT=9000
python mcp_server.py
```

### Change Ollama Model
In `mcp_server.py`, change:
```python
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "qwen2.5:1.5b")
```

Or set environment variable:
```bash
export OLLAMA_MODEL=qwen2.5:3b
python mcp_server.py
```

### Update MCP Server URL in Flutter
If your MCP server is not on localhost, update:
- `pocketbase_service.dart`: Change `mcpServerUrl` constant
- `tool_import_config_screen.dart`: Change `_mcpServerUrl` constant

---

## Adding New Vendors

To add support for more vendors (e.g., McMaster-Carr, MSC Direct):

1. Edit `mcp_server.py`
2. Add to `VENDOR_URL_PATTERNS` dictionary:
   ```python
   VENDOR_URL_PATTERNS = {
       "harvey": "https://www.harveytool.com/products-en-ca/en-ca-tool-details-{model}",
       "mcmaster": "https://www.mcmaster.com/{model}",  # Add new vendors here
   }
   ```
3. Restart the MCP server
4. The new vendor will automatically appear in the config screen

---

## Disabling the Feature

If you need to disable the feature:

1. **In the app:** Go to Settings → Turn OFF "Enable Auto Tool Import"
2. **Stop the MCP server:** Just stop the Python process (Ctrl+C)
3. **Remove from systemd:** `sudo systemctl stop cribhub-mcp.service && sudo systemctl disable cribhub-mcp.service`

The app will work normally with the feature disabled. No data is affected.

---

## Cost Analysis

**This solution is 100% free!**
- ✅ Ollama: Free and open source
- ✅ Qwen2.5: Free model
- ✅ MCP Server: Your own hardware
- ✅ No API costs, no subscriptions

**Resource usage:**
- Qwen2.5 1.5B: ~2GB RAM
- MCP Server: ~50MB RAM
- First import: ~10 seconds
- Subsequent imports: ~3-5 seconds

---

## Need Help?

Common issues and solutions:

1. **Import button doesn't appear**
   - Make sure "Enable Auto Tool Import" is ON in Settings
   - Check that `_enableToolImport` setting is being loaded correctly

2. **"Brand not supported"**
   - Only Harvey Tool is configured by default
   - Add more vendors to `VENDOR_URL_PATTERNS`

3. **Data extraction is wrong**
   - The LLM isn't perfect
   - Review and manually correct after import
   - Try the 3B model for better accuracy

---

That's it! The feature is now ready to use. Start with Harvey Tool and expand to other vendors as needed.
