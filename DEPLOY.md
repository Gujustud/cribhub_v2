# CribHub Deployment Guide

Build and deploy the CribHub **web app** to the Proxmox / PocketBase server at `https://cribhub.sscadcam.com`.

**Stack:** Flutter web → `build/web/` → zip → server. Static files live in `/opt/pocketbase/pb_public`; Nginx serves them.

---

## Copying commands

Command blocks below use **indented lines** (no backticks). Select and copy the lines that start with spaces—PowerShell and bash ignore leading spaces, so you won't get the "backticks not recognized" error.

---

## 1. URLs (build time)

The app reads **`lib/app_config.dart`** for `PocketBaseUrl` and `McpUrl`. Values are set at build time via `--dart-define`:

| Environment | PocketBase | MCP |
|-------------|------------|-----|
| Local (no defines) | `http://localhost:8090` | `http://localhost:8001` |
| Production | `https://cribhub.sscadcam.com/` | `https://cribhub.sscadcam.com/mcp` |

**Local dev:** Start PocketBase on 8090 and MCP on 8001, then run:

    cd c:\cribhub
    flutter run -d chrome

---

## 2. Build and zip (laptop)

**Step 1 – Production build**

From repo root, run the build script. It updates About-page git info and builds with production URLs:

    cd c:\cribhub
    .\scripts\build_web.ps1

Output is in `build\web\` (index.html, assets/, main.dart.js, etc.).

**Step 2 – Create deployment zip**

Zip the **contents** of `build\web`, not the `web` folder itself:

    cd c:\cribhub
    mkdir deploy -ErrorAction SilentlyContinue
    Remove-Item deploy\dist.zip -ErrorAction SilentlyContinue
    Compress-Archive -Path build\web\* -DestinationPath deploy\dist.zip -Force

You should have `deploy\dist.zip`. Unzipped, it must give `index.html` at the top level, not `web/index.html`. If you see `web/index.html`, you zipped the folder; use `build\web\*` instead.

**Automated laptop script:** `.\scripts\deployweb.bat` runs the build, creates `deploy\dist.zip`, **validates** the zip (size, required root files, `main.dart.js` sanity, rejects `web/index.html` layout mistakes), prints a **SHA256** you can compare after `curl`, then starts the HTTP server. It prefers **`tar`** for the zip step when available (often more reliable than `Compress-Archive` for large Flutter web output).

**Step 3 – Serve the zip**

On the laptop, serve the deploy folder so the server can download the zip:

    cd c:\cribhub\deploy
    python -m http.server 8888

Leave this running. Get your laptop’s LAN IP with `ipconfig` (e.g. 192.168.1.247). The server will use `http://<LAPTOP_IP>:8888/dist.zip`.

---

## Android APK (production)

To avoid localhost config in tablet builds, always use the production APK script:

    cd c:\cribhub
    .\scripts\buildapk.bat

This runs:

    flutter build apk --release --dart-define=POCKETBASE_URL=https://cribhub.sscadcam.com/ --dart-define=MCP_URL=https://cribhub.sscadcam.com/mcp

Output:

    build\app\outputs\flutter-apk\app-release.apk

Note: Release builds now have a startup guard. If an APK is built with localhost URLs, the app shows a configuration error screen with rebuild instructions instead of silently failing API calls.

---

## 3. Deploy on the server

Run these on the CribHub container (SSH). Replace `192.168.1.247` with your laptop IP if different.

**Download zip**

    cd ~
    rm -f dist.zip
    curl -O http://192.168.1.247:8888/dist.zip
    ls -la dist.zip

**Clear old app files**

    cd /opt/pocketbase/pb_public
    rm -f main.dart.js index.html flutter.js flutter_bootstrap.js flutter_service_worker.js manifest.json version.json .last_build_id favicon.png
    rm -rf assets canvaskit icons

**Unzip new build**

    cd /opt/pocketbase/pb_public
    unzip -o ~/dist.zip
    ls -la

You should see `index.html`, `assets/`, `canvaskit/`, `icons/`, `main.dart.js`, etc. at the top level. If everything is under `web/`, the zip was wrong; recreate it from `build\web\*`.

---

## 4. Nginx

Nginx is configured in `/etc/nginx/sites-available/cribhub`. Root is `/opt/pocketbase/pb_public` with `try_files $uri $uri/ /index.html`. No change needed unless you move the app.

---

## 5. After deploy – browser cache

Flutter web uses a service worker. If the site still shows the old version:

1. Chrome → F12 → **Application** → **Storage** → **Clear site data** for the origin.
2. Hard refresh (Ctrl+Shift+R).

Or open the site in a **private/incognito** window.

Check the About screen for the new git hash and confirm data loads from PocketBase.

---

## 6. Optional

**PocketBase migrations**  
If you have a `pb_migrations.zip`, unzip it into the migrations directory (next to the `pb` binary), then restart PocketBase.

**Purchase tracking**  
For the Purchases feature, create two collections in PocketBase admin (**Settings → Collections**):

- **`purchases`**  
  `purchase_date` (date, required), `supplier` (relation → suppliers), `order_reference` (text), `notes` (text), `total` (number).

- **`purchase_items`**  
  `purchase` (relation → purchases), `tool` (relation → inventory; optional for tax/shipping), `quantity` (number, required), `unit_cost` (number), `line_type` (text: item / tax / shipping), `description` (text).

Set list/create/update rules for your auth (e.g. authenticated users).

**Tool notes (edit screen)**  
The Add/Edit Tool screen saves a **Notes** field on the `inventory` collection. Add a text field **`notes`** (optional) to the `inventory` collection if update fails with an unknown field error.

---

## Quick reference

**Laptop**

    cd c:\cribhub
    .\scripts\build_web.ps1
    mkdir deploy -ErrorAction SilentlyContinue
    Remove-Item deploy\dist.zip -ErrorAction SilentlyContinue
    Compress-Archive -Path build\web\* -DestinationPath deploy\dist.zip -Force
    cd deploy
    python -m http.server 8888

**Android APK**

    cd c:\cribhub
    .\scripts\buildapk.bat

**Server**

    cd ~ && curl -O http://192.168.1.247:8888/dist.zip
    cd /opt/pocketbase/pb_public
    rm -f main.dart.js index.html flutter.js flutter_bootstrap.js flutter_service_worker.js manifest.json version.json .last_build_id favicon.png
    rm -rf assets canvaskit icons
    unzip -o ~/dist.zip

Then hard-refresh the browser or clear site data.
