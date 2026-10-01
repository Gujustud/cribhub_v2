# Shop next (new DharmaCore CT)

Living list so we don’t rely on chat history. Update this when something is done.

**Live shop (use this):** `https://dharmacore.sscadcam.com/` → CT **105**, LAN `192.168.20.101`  
**Logins:** PocketBase **`users`** (not `/_/` admin). This PC may use a `hosts` line to `.101`. **Do not** port-forward **443** to the internet.

**Leave running:** Cribhub CT **101** (`.102`), old DharmaCore CT **102** (`.103`), erp-dev CT **103** (`.104`).

---

## App / product

- [ ] **Users screen** in the app (list/edit shop logins: email, `role`, `wiki_owner`, `wiki_readonly`) so you are not stuck in PocketBase Admin. Wiki visibility stays flexible for that later.
- [ ] Wiki on live CT 105: copy `pb_migrations/1775000000_wiki_pages_and_user_flags.js`, restart PocketBase, set your user **`wiki_owner` = true**, deploy a new web zip. Paste Notion as markdown.
- [ ] Chrome **Not secure** on the HTTPS shop: mixed HTTP content. Optional; cert is valid.
- [ ] Bitwarden autofill: often blocked by that warning + Flutter fields. Copy/paste or Fill from the extension until mixed content is gone.
- [ ] Extra shop logins: create more records in PocketBase **`users`**.
- [ ] Tablets/phones: release APK still points at **cribhub.sscadcam.com** unless rebuilt for this host.
- [ ] Inventory barcode scanning (`lib/inventory_home_screen.dart`) — old code TODO, not part of the merge.

## Ops (only if it bites you)

- [ ] UniFi **DNS Host (A)** `dharmacore.sscadcam.com` → `192.168.20.101` if some LAN device still misses the new site (skip if WiFiman/phone already work).
- [ ] Next Let’s Encrypt renew: HTTP-01 needs WAN **80** to CT **102** (or move Certbot to **105**), then copy certs **102 → 105** again. Do not leave **80** open.
- [ ] Commit `scripts/migrate_dcore/migrate.js` superuser (`_superusers`) auth fallback if you want that in git. **Never commit** `scripts/migrate_dcore/.env`.

## Done (this cutover)

- Cribhub `pb_data` on CT 105; ERP import from `.103`; Flutter zip for `https://dharmacore.sscadcam.com/`; Nginx + renewed cert on 105.
