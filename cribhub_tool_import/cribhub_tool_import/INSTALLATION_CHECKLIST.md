# Installation Checklist

Follow this checklist to install the CribHub Tool Import feature.

## ☐ Phase 1: PocketBase (2 minutes)

- [ ] Open PocketBase Admin UI (http://127.0.0.1:8090/_/)
- [ ] Go to Collections → `app_settings`
- [ ] Click "Edit collection" → "+ New field"
- [ ] Add Boolean field named `enable_tool_import`, default: `false`
- [ ] Click "Save"

✅ **PocketBase is ready!** (Feature is disabled by default, safe to deploy)

---

## ☐ Phase 2: MCP Server Setup (5 minutes)

### Prerequisites Check
- [ ] Python 3.8+ installed: `python --version` or `python3 --version`
- [ ] Ollama installed: `ollama --version`
- [ ] Qwen2.5 downloaded: `ollama list` (should show qwen2.5:1.5b)

### Installation
- [ ] Create folder: `mkdir ~/cribhub-mcp-server`
- [ ] Copy these files to the folder:
  - [ ] `mcp_server.py`
  - [ ] `requirements.txt`
  - [ ] `start_mcp_server.bat` (Windows) or `start_mcp_server.sh` (Linux/Mac)
  - [ ] `test_mcp_server.py`
- [ ] Install dependencies: `pip install -r requirements.txt`
- [ ] Start server: `python mcp_server.py`
- [ ] Test in browser: http://localhost:8001 (should show JSON status)

✅ **MCP Server is running!**

---

## ☐ Phase 3: Test MCP Server (2 minutes)

- [ ] Open new terminal in MCP server folder
- [ ] Run: `python test_mcp_server.py`
- [ ] All tests pass ✅
- [ ] If tests fail, follow troubleshooting in output

✅ **MCP Server is working correctly!**

---

## ☐ Phase 4: Flutter App Updates (10 minutes)

### Add New Files
- [ ] Copy `tool_import_config_screen.dart` → `lib/tool_import_config_screen.dart`

### Update Existing Files

#### settings_screen.dart
- [ ] Backup current file: `cp lib/settings_screen.dart lib/settings_screen.dart.backup`
- [ ] Replace with new version: `settings_screen.dart`
- [ ] Verify it compiles: `flutter analyze lib/settings_screen.dart`

#### pocketbase_service.dart
- [ ] Open `lib/pocketbase_service.dart` in editor
- [ ] Open `pocketbase_service_additions.dart` for reference
- [ ] Add imports (if missing):
  ```dart
  import 'package:http/http.dart' as http;
  import 'dart:convert';
  ```
- [ ] Update `updateAppSettings()` method to include `enableToolImport` parameter
- [ ] Add new `importToolSpecs()` method at the end of the class
- [ ] Verify it compiles

#### add_tool_screen.dart
- [ ] Open `lib/add_tool_screen.dart` in editor
- [ ] Open `add_tool_screen_additions.dart` for reference
- [ ] Follow the 7 numbered steps in the additions file:
  - [ ] Step 1: Add state variables (`_enableToolImport`, `_isImporting`)
  - [ ] Step 2: Update `_loadSettings()` method
  - [ ] Step 3: Add `_importToolSpecs()` method
  - [ ] Step 4: Add `_showImportPreviewDialog()` method
  - [ ] Step 5: Add `_buildPreviewField()` helper
  - [ ] Step 6: Add `_applyImportedData()` method
  - [ ] Step 7: Update Model Number field with Import button
- [ ] Verify it compiles: `flutter analyze lib/add_tool_screen.dart`

✅ **Flutter app is updated!**

---

## ☐ Phase 5: Final Testing (5 minutes)

### Start Everything
- [ ] Ollama running (usually automatic)
- [ ] MCP Server running: `python mcp_server.py`
- [ ] PocketBase running: `./pocketbase serve`
- [ ] Flutter app: `flutter run`

### Test in App
- [ ] Open app → Settings
- [ ] Turn ON "Enable Auto Tool Import"
- [ ] (Optional) Click "Configure Tool Import" → verify server shows as online
- [ ] Go to "Add Tool"
- [ ] Select Brand: "Harvey Tool"
- [ ] Enter Model Number: `814193`
- [ ] Click "Import" button (appears next to model number)
- [ ] Wait 5-10 seconds
- [ ] Preview dialog appears with extracted data
- [ ] Click "Import" to populate fields
- [ ] Verify fields are populated: diameter, flutes, flute length
- [ ] Save the tool

✅ **Feature is working!**

---

## ☐ Phase 6: Production Deployment (Optional)

### For Mini PC at Shop

- [ ] Copy MCP server folder to mini PC: `scp -r ~/cribhub-mcp-server user@minipc:~/`
- [ ] SSH into mini PC: `ssh user@minipc`
- [ ] Test manually: `cd ~/cribhub-mcp-server && python3 mcp_server.py`
- [ ] Stop with Ctrl+C

### Run as System Service (Recommended)

- [ ] Create systemd service file (see INSTALLATION_GUIDE.md)
- [ ] Enable service: `sudo systemctl enable cribhub-mcp.service`
- [ ] Start service: `sudo systemctl start cribhub-mcp.service`
- [ ] Check status: `sudo systemctl status cribhub-mcp.service`
- [ ] View logs: `sudo journalctl -u cribhub-mcp.service -f`

✅ **Production deployment complete!**

---

## Troubleshooting Checklist

If something doesn't work:

### MCP Server Issues
- [ ] Check Python version: `python --version` (need 3.8+)
- [ ] Check Ollama: `ollama list` (should show qwen2.5:1.5b)
- [ ] Check port 8001 not in use: `netstat -an | grep 8001`
- [ ] Check server logs for errors
- [ ] Run test script: `python test_mcp_server.py`

### Flutter App Issues
- [ ] Run `flutter clean && flutter pub get`
- [ ] Check compilation: `flutter analyze`
- [ ] Setting not loading? Check PocketBase has the field
- [ ] Import button not showing? Verify `_enableToolImport` is true
- [ ] Network error? Check MCP server URL in `pocketbase_service.dart`

### Import Not Working
- [ ] Verify brand is supported (currently only Harvey Tool)
- [ ] Check model number format (numbers only for Harvey: 814193)
- [ ] Wait longer - first import can take 10+ seconds
- [ ] Check MCP server logs for errors
- [ ] Try different model number

---

## Quick Reference Commands

### Windows
```powershell
# Start MCP Server
cd ~/cribhub-mcp-server
python mcp_server.py

# Test MCP Server
python test_mcp_server.py

# Check Ollama
ollama list
```

### Linux/Mac
```bash
# Start MCP Server
cd ~/cribhub-mcp-server
./start_mcp_server.sh

# Or manually:
python3 mcp_server.py

# Test MCP Server
python3 test_mcp_server.py

# Check Ollama
ollama list
```

---

## Success Criteria

You'll know everything is working when:

✅ PocketBase has `enable_tool_import` field
✅ MCP server starts without errors
✅ Test script passes all tests
✅ Flutter app compiles without errors
✅ Import toggle appears in Settings
✅ Import button appears when enabled
✅ Test import (Harvey 814193) populates fields correctly

---

## Time Estimate

- **Minimum time:** 20 minutes (if everything goes smoothly)
- **Average time:** 30-45 minutes (with troubleshooting)
- **First time setup:** Allow 1 hour

---

## Need Help?

Check the detailed guide: **INSTALLATION_GUIDE.md**

Common issues and solutions are documented there.

---

**Good luck! 🚀**
