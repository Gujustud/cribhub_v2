# DharmaCore authentication

## Overview

DharmaCore uses PocketBase **`users`** auth (same model as DharmaCore):

- Email + password login in the app
- Optional **`role`** on each user: `full` (default) or `jobs_only`
- Optional **`wiki_owner`** (bool): can read **owner-only** wiki pages
- Optional **`wiki_readonly`** (bool): can read the wiki but not create/edit/delete
- API rules enforce login; `jobs_only` cannot access `quotes` / `quote_line_items`

Wiki (`wiki_pages`): nested **parent** tree, markdown **body**, **visibility** `everyone` | `staff` | `owner`. `staff` is hidden from `jobs_only`. `owner` requires `wiki_owner`. Files in **attachments**.

## PocketBase setup

1. Run migrations on your PocketBase instance (restart `pocketbase serve` so `pb_migrations/1774000000_erp_auth_and_jobs_only_role.js` applies).
2. In Admin → **Collections → users**, create accounts (email + password).
3. For shop-floor users, set **role** = `jobs_only`. Leave role empty or `full` for office users.

## First login

After migrations, the app requires sign-in. Create at least one user in PocketBase Admin before locking down erp-dev.

## Flutter

- `lib/auth_service.dart` — login, logout, role helpers
- `lib/login_screen.dart` — sign-in UI
- `lib/auth_gate.dart` — wraps the app home until authenticated
- `lib/wiki_screen.dart` / `lib/wiki_edit_screen.dart` — wiki under Shop ERP

## `jobs_only` (step 2+)

UI hides Quotes and quote-related settings for `jobs_only` users. Server rules already block quote API access for that role.
