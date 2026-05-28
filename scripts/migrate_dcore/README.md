# Migrate DharmaCore → erp-dev PocketBase

Copies ERP data from **DharmaCore’s** PocketBase into **erp-dev** (`192.168.20.104:8091`) via the Admin API.

| Source (DharmaCore) | Target (Cribhub erp-dev) |
|---------------------|---------------------------|
| `vendors` | `suppliers` (match by `company_name` ← vendor `name`) |
| `customers` | `customers` |
| `quotes` | `quotes` |
| `quote_line_items` | `quote_line_items` |
| `jobs` | `jobs` |
| `settings` | `settings` (update first row or create) |

Also copies **`part_images`** files on quotes and jobs when present.

Does **not** touch Cribhub inventory, purchases, brands, etc.

## Prerequisites

- Node.js 18+
- Admin credentials for **both** PocketBase instances
- Network access from your PC to DharmaCore PB and erp-dev PB
- ERP collections already exist on erp-dev (schema matches DharmaCore)

## Setup

```powershell
cd c:\cribhub\scripts\migrate_dcore
copy .env.example .env
# Edit .env — set URLs and admin email/password for both servers
npm install
```

### URLs

| Variable | Example |
|----------|---------|
| `DCORE_PB_URL` | `http://192.168.20.103:8090/` or `https://dharmacore.sscadcam.com/` |
| `TARGET_PB_URL` | `http://192.168.20.104:8091/` |

Use the **internal** IP/hostname your PC can reach (Teleport/VPN/LAN).

## Run

Dry run (no writes):

```powershell
npm run dry-run
```

Live import:

```powershell
npm run migrate
```

### Re-import from scratch

To delete existing ERP rows on the target first (customers, quotes, line items, jobs — **not** suppliers/inventory):

```env
WIPE_ERP_BEFORE_IMPORT=1
```

Then run `npm run migrate`.

## After migration

1. Open erp-dev Flutter app → Customers, Quotes, Jobs.
2. PocketBase Admin `http://192.168.20.104:8091/_/` → verify record counts.
3. Open one quote with line items and check material vendor (supplier) links.

## Wrapper (optional)

From repo root:

```powershell
.\scripts\run_migrate_dcore.ps1
```
