# CribHub ERP dev deployment (`erp-dev`)

Deploy the **Flutter web** build to the **erp-dev** Proxmox LXC (shop ERP / PocketBase experiments). This is separate from production CribHub; see **`DEPLOY.md`** for `cribhub.sscadcam.com`.

**Stack on the CT:** Flutter static files → `/opt/pocketbase-erp-dev/pb_public/` → Nginx (port 80). PocketBase dev instance → `/opt/pocketbase-erp-dev/`, HTTP **`0.0.0.0:8091`** (systemd unit **`pocketbase-erp-dev.service`**).

**Default URLs baked into the erp-dev web build:** `http://192.168.20.104:8091/` (PocketBase) and `http://192.168.20.104/mcp` (MCP). Override at build time with environment variables (see **`scripts/build_web_erp_dev.ps1`**).

---

## Copying commands

Command blocks below use **indented lines** (no backticks). Select and copy the lines that start with spaces—PowerShell and bash ignore leading spaces, so you won't get the "backticks not recognized" error.

---

## 1. Build on the laptop (Windows)

From the repo root, run the **erp-dev** script. It refreshes git info for the About page, runs `flutter build web` with the dev `dart-define` values, **checks** that `main.dart.js` does not contain the old CT IP (`192.168.1.90`) and does contain the expected PocketBase host, then creates **`deploy\erp-dev-web.zip`**.

    cd c:\cribhub
    .\scripts\build_web_erp_dev.ps1

Outputs:

- **`build\web\`** — full web output (same files that go on the server).
- **`deploy\erp-dev-web.zip`** — validated zip whose root is `index.html`, `main.dart.js`, `assets/`, etc. (not `web\index.html`).

To point at another host without editing the script (same PowerShell session):

    $env:CRIBHUB_ERP_POCKETBASE_URL = 'http://erp-dev.sscadcam.com:8091/'
    $env:CRIBHUB_ERP_MCP_URL = 'http://erp-dev.sscadcam.com/mcp'
    cd c:\cribhub
    .\scripts\build_web_erp_dev.ps1

---

## 2. Copy the zip to the CT

Pick **one** method.

### Option A — `scp` from the laptop (simple)

Replace **`root@192.168.20.104`** if your SSH user or CT IP differs.

    scp c:\cribhub\deploy\erp-dev-web.zip root@192.168.20.104:/root/

### Option B — HTTP download from the laptop (like main DEPLOY.md)

On the laptop, serve the deploy folder:

    cd c:\cribhub\deploy
    python -m http.server 8888

On the CT, replace **`192.168.x.x`** with your laptop’s IP (from `ipconfig`):

    cd ~
    rm -f erp-dev-web.zip
    curl -O http://192.168.x.x:8888/erp-dev-web.zip
    ls -la erp-dev-web.zip

---

## 3. Install on the CT (SSH as root or sudo)

These steps **replace** the live static site under PocketBase’s public directory. They do **not** replace `pb_data` or the PocketBase binary unless you do that separately.

### 3a. Clear old web files

    rm -rf /opt/pocketbase-erp-dev/pb_public/*

### 3b. Unzip into `pb_public`

If you used **Option A** and the file is **`/root/erp-dev-web.zip`**:

    unzip -o /root/erp-dev-web.zip -d /opt/pocketbase-erp-dev/pb_public/

If you used **Option B** and the file is **`~/erp-dev-web.zip`**:

    unzip -o ~/erp-dev-web.zip -d /opt/pocketbase-erp-dev/pb_public/

### 3c. Verify layout

You must see **`index.html`** and **`main.dart.js`** directly under **`pb_public`**, not under **`pb_public/web/`**.

    ls -la /opt/pocketbase-erp-dev/pb_public/

Quick local check (optional):

    curl -sI http://127.0.0.1/ | head -5

Nginx should answer with **200** (or **304**) for `/` if the vhost points at this directory.

### 3d. PocketBase / Nginx

- **Static-only deploy:** no need to restart PocketBase for new `main.dart.js` / assets.
- If you changed **Nginx** config: **`nginx -t`** then **`systemctl reload nginx`**.
- If PocketBase was stopped: **`systemctl start pocketbase-erp-dev`** (exact unit name may match how you created it).

---

## 4. Nginx and hostname (reference)

Typical layout on the CT:

- **Site config:** `/etc/nginx/sites-available/erp-dev` (symlinked into **`sites-enabled`**).
- **`root`** for the Flutter site: **`/opt/pocketbase-erp-dev/pb_public`** with SPA-style **`try_files`** (same idea as production CribHub).

**`server_name`** should include the hostname and/or IP you use in the browser (for example **`erp-dev.sscadcam.com`** and **`192.168.20.104`**). Adjust when the CT IP or DNS changes.

---

## 5. After deploy — browser

Flutter web caches aggressively (service worker).

1. Open the site (prefer **`http://`** until TLS is configured for erp-dev).
2. Chrome → F12 → **Application** → **Storage** → **Clear site data** for that origin.
3. Hard refresh (**Ctrl+Shift+R**) or use a private window.

If Inventory or other screens still call an **old PocketBase IP**, the browser was still running an **old** `main.dart.js`: clear site data again, or confirm you deployed the zip from the latest **`build_web_erp_dev.ps1`** run.

---

## 6. Optional — sync migrations from the repo clone on the CT

If **`/opt/cribhub`** tracks git and you want PocketBase to see the same migration files as your laptop:

    cd /opt/cribhub
    git pull
    cp -a /opt/cribhub/pb_migrations/. /opt/pocketbase-erp-dev/pb_migrations/
    systemctl restart pocketbase-erp-dev

Only do this when you intend schema changes; test on erp-dev before production.

---

## 7. DNS and “still wrong page in browser”

Internal **`erp-dev.sscadcam.com`** should resolve to the CT (for example **`192.168.20.104`**). If **`nslookup`** from a PC shows a **public** IP but **`curl http://erp-dev.sscadcam.com/`** from the same PC is correct, Chrome **Secure DNS** may be bypassing your LAN DNS—turn it off for testing, or use a **hosts** file line on the laptop until UniFi local DNS applies to all clients.

---

## 8. PocketBase URL vs browser origin (CORS)

The default web build talks to PocketBase at **`http://192.168.20.104:8091/`** while the site is often served at **`http://192.168.20.104/`** (port **80**). Different ports count as **different origins**; the browser may block API calls (**Failed to fetch**, status **0**) unless PocketBase allows your web origin in CORS or you **reverse-proxy** PocketBase under the same host and port as the page (recommended long-term, mirroring production).

If you hit that after a correct deploy, fix CORS on the dev PocketBase instance or add an Nginx **`location`** proxy to **`127.0.0.1:8091`**, then rebuild with a **`POCKETBASE_URL`** that matches the proxied URL (no separate port in the browser).

---

## Quick reference

| Item | Value |
|------|--------|
| CT web root | `/opt/pocketbase-erp-dev/pb_public/` |
| PocketBase dir | `/opt/pocketbase-erp-dev/` |
| PocketBase listen | `8091` (example: `serve --http="0.0.0.0:8091"`) |
| Laptop build script | `.\scripts\build_web_erp_dev.ps1` |
| Laptop zip | `deploy\erp-dev-web.zip` |

Production CribHub deploy is unchanged: **`DEPLOY.md`** and **`.\scripts\build_web.ps1`**.
