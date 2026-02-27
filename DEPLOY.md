## CribHub Deployment Guide

This doc covers how to build and deploy the CribHub **web app** to the Proxmox / PocketBase server that serves `https://cribhub.sscadcam.com`.

The stack:
- Flutter web app (built to `build/web/`)
- PocketBase + Nginx on the server
- Static files served from `/opt/pocketbase/pb_public`

---

## 1. URLs and environments

Runtime URLs come from **`lib/app_config.dart`**:

- `AppConfig.pocketBaseUrl`
- `AppConfig.mcpUrl`

These values are set at **build time** via `--dart-define`:

- Local dev defaults (no defines):
  - PocketBase: `http://localhost:8090`
  - MCP: `http://localhost:8001`
- Production (server build):
  - PocketBase: `https://cribhub.sscadcam.com/`
  - MCP: `https://cribhub.sscadcam.com/mcp`

### Local development

1. Start PocketBase and the MCP server locally:
   - PocketBase on `http://localhost:8090`
   - MCP server on `http://localhost:8001`

2. Run the Flutter app:

   ```bash
   cd c:\cribhub
   flutter run -d chrome
   ```

   No `--dart-define` flags needed; the defaults in `AppConfig` will point at `localhost`.

---

## 2. Production web build (on laptop)

Always build with explicit server URLs so the deployed app talks to the server, not localhost.

```powershell
cd c:\cribhub
flutter build web `
  --dart-define=POCKETBASE_URL=https://cribhub.sscadcam.com/ `
  --dart-define=MCP_URL=https://cribhub.sscadcam.com/mcp
```

This creates the production web bundle under:

```text
c:\cribhub\build\web\
  index.html
  assets/
  main.dart.js
  ...
```

### Create the deployment zip

Create a small `deploy` folder and zip **the contents of `build/web`** (not the `web` folder itself):

```powershell
cd c:\cribhub
mkdir deploy -ErrorAction SilentlyContinue
Remove-Item deploy\dist.zip -ErrorAction SilentlyContinue

Compress-Archive -Path build\web\* -DestinationPath deploy\dist.zip -Force
```

After this you should have:

```text
c:\cribhub\deploy\dist.zip
```

The zip should unpack to:

```text
index.html
assets/
canvaskit/
icons/
...
```

> If the zip unpacks to `web/index.html`, you zipped the folder instead of its contents. Always zip `build\web\*`, not `build\web`.

---

## 3. Serve the zip from the laptop

From your laptop, start a simple HTTP server in the `deploy` folder:

```powershell
cd c:\cribhub\deploy
python -m http.server 8888
```

Leave this running during deploy.

Find your laptop’s LAN IP (e.g. `192.168.1.247`) via:

```powershell
ipconfig
```

Use the IPv4 address of the LAN adapter; the server must be able to reach `http://<LAPTOP_IP>:8888/`.

---

## 4. Nginx / web root on the server

On the CribHub container, Nginx is configured in:

```text
/etc/nginx/sites-available/cribhub
```

Key part:

```nginx
location / {
    root /opt/pocketbase/pb_public;
    try_files $uri $uri/ /index.html;
    index index.html;
}
```

So **`/opt/pocketbase/pb_public`** must contain `index.html`, `assets/`, etc.

---

## 5. Deploy steps on the server

All commands below run on the CribHub container (SSH as `root` or equivalent).

### 5.1 Download the new build

Replace `192.168.1.247` with your laptop IP if it changes.

```bash
cd ~
rm -f dist.zip
curl -O http://192.168.1.247:8888/dist.zip
ls -la dist.zip
```

Confirm `dist.zip` looks roughly the right size (several MB).

### 5.2 Clear old app files

Remove the previous web build so nothing stale is left:

```bash
cd /opt/pocketbase/pb_public

rm -f main.dart.js index.html flutter.js flutter_bootstrap.js \
      flutter_service_worker.js manifest.json version.json \
      .last_build_id favicon.png

rm -rf assets canvaskit icons
```

### 5.3 Unzip the new build

```bash
cd /opt/pocketbase/pb_public
unzip -o ~/dist.zip
ls -la
```

You should now see:

```text
index.html
assets/
canvaskit/
icons/
main.dart.js
...
```

If instead everything is under `web/` (e.g. `web/index.html`), then the zip was created incorrectly; go back and recreate `dist.zip` from `build\web\*`.

### 5.4 (Optional) Migrations

If you’ve changed PocketBase migrations and created a `pb_migrations.zip`, unzip it where the PocketBase binary expects migrations (typically next to the `pb` binary):

```bash
cd /opt/pocketbase/pb_migrations
unzip -o ~/pb_migrations.zip
```

Restart PocketBase if needed, then it will apply new migrations on startup.

---

## 6. Verify deployment

### 6.1 Check the bundle for the expected commit (optional)

On the server:

```bash
grep -o "938229a" /opt/pocketbase/pb_public/main.dart.js | head -1
```

Replace `938229a` with the short hash you expect (e.g. from `lib/git_info.dart`). Seeing it here confirms the new build is on disk.

### 6.2 Browser cache and service worker

Flutter web registers a service worker (`flutter_service_worker.js`) that can cache old bundles. If the site still looks old after deploy:

1. Open `https://cribhub.sscadcam.com` in Chrome.
2. Open DevTools (F12) → **Application** → **Storage**.
3. Click **Clear site data** for this origin (cookies, cache, storage, service workers).
4. Reload the page (Ctrl+Shift+R).

Alternatively, open the site in a **private/incognito** window, which bypasses the existing service worker.

When everything is correct, the About screen should show the new short hash from `lib/git_info.dart`, and inventory data should load from the live PocketBase.

---

## 7. Quick reference

### Laptop (build + zip)

```powershell
cd c:\cribhub

# Production build (talks to live server)
flutter build web `
  --dart-define=POCKETBASE_URL=https://cribhub.sscadcam.com/ `
  --dart-define=MCP_URL=https://cribhub.sscadcam.com/mcp

# Create dist.zip from build/web contents
mkdir deploy -ErrorAction SilentlyContinue
Remove-Item deploy\dist.zip -ErrorAction SilentlyContinue
Compress-Archive -Path build\web\* -DestinationPath deploy\dist.zip -Force

# Serve it
cd c:\cribhub\deploy
python -m http.server 8888
```

### Server (download + deploy)

```bash
# Download
cd ~
curl -O http://192.168.1.247:8888/dist.zip

# Clear old build
cd /opt/pocketbase/pb_public
rm -f main.dart.js index.html flutter.js flutter_bootstrap.js \
      flutter_service_worker.js manifest.json version.json \
      .last_build_id favicon.png
rm -rf assets canvaskit icons

# Unzip new build
unzip -o ~/dist.zip
```

Then hard-refresh the browser or clear site data if needed.

