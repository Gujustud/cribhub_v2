# Purchase Section – Full Technical Write-up

This document describes how the **Purchase** feature was built in the Cribhub Flutter app: data model, backend (PocketBase), API layer, screens, navigation, and integration with the rest of the app. Use it to understand or fix the purchase screen with Claude or another assistant.

---

## 1. Overview

The purchase section lets users:

- **List** all purchases (date, supplier, order ref, total).
- **Add** a new purchase (full-screen form with date, supplier, order ref, notes, line items, GST/PST, total).
- **Edit** an existing purchase by tapping a row: opens the same form pre-filled; supports update and delete.
- **Link tools to purchases** via line items; tool edit screen shows “Price over time” from purchase history.

All purchase data is stored in **PocketBase** in two collections: `purchases` and `purchase_items`.

---

## 2. File Map

| Purpose | File path |
|--------|-----------|
| **Models** | `lib/models.dart` – `Purchase`, `PurchaseItem` |
| **API / Backend calls** | `lib/pocketbase_service.dart` – purchase and purchase_items CRUD |
| **Purchases list screen** | `lib/purchases_screen.dart` – list + “Add Purchase” + tap to edit |
| **Add/Edit purchase form** | `lib/add_purchase_screen.dart` – full form (create and edit) |
| **Navigation (drawer)** | `lib/app_drawer.dart` – “Purchases” entry → `PurchasesScreen` |
| **Tool screen integration** | `lib/add_tool_screen.dart` – “Price over time” uses `getPurchaseItemsByTool` |
| **Deploy / schema notes** | `DEPLOY.md` – optional PocketBase collection setup (see §5.3) |

No separate router file: navigation is `Navigator.push` with `MaterialPageRoute` to `PurchasesScreen` and `AddPurchaseScreen`.

---

## 3. Data Models (`lib/models.dart`)

### 3.1 `Purchase`

Represents one purchase (header only; line items are separate).

| Field | Type | Source (PocketBase) | Notes |
|-------|------|---------------------|--------|
| `id` | String | record.id | PocketBase record id |
| `purchaseDate` | DateTime | `purchase_date` | Required |
| `supplierId` | String? | `supplier` | Relation id → suppliers |
| `orderReference` | String? | `order_reference` | Optional |
| `notes` | String? | `notes` | Optional |
| `total` | double? | `total` | Optional (can be computed from items) |
| `supplierName` | String? | expand `supplier` → `company_name` | For display |

- **Factory:** `Purchase.fromRecord(dynamic record)` – builds from PocketBase record; handles `record.data` and `record.expand['supplier']` for `supplierName`.

### 3.2 `PurchaseItem`

One line on a purchase: product (tool), shipping, or tax.

| Field | Type | Source (PocketBase) | Notes |
|-------|------|---------------------|--------|
| `id` | String | record.id | |
| `purchaseId` | String | `purchase` | Relation → purchases |
| `toolId` | String? | `tool` | Relation → inventory; null for tax/shipping |
| `quantity` | int | `quantity` | Required; 1 for tax/shipping |
| `unitCost` | double? | `unit_cost` | Unit price (items) or amount (tax/shipping) |
| `toolName` | String? | expand `tool` → `tool_name` | For display |
| `lineType` | String | `line_type` | `'item'` \| `'tax'` \| `'shipping'` |
| `description` | String? | `description` | e.g. "GST", "PST", "Shipping" |

- **Factory:** `PurchaseItem.fromRecord(dynamic record)` – uses `record.data` and `record.expand['tool']` for `toolName`.
- **Helpers:** `isItem`, `isTax`, `isShipping` getters.

---

## 4. PocketBase Service (`lib/pocketbase_service.dart`)

All purchase-related methods live in the same `PocketBaseService` class used for the rest of the app.

### 4.1 Purchases (header)

- **`getPurchases({ String? supplierId })`**  
  - Returns `List<dynamic>` of raw PocketBase records.  
  - Uses collection `purchases`, sort `-purchase_date`, expand `supplier`.  
  - If `supplierId` is set, filters by `supplier = "<id>"`.

- **`createPurchase({ required DateTime purchaseDate, String? supplierId, String? orderReference, String? notes, double? total })`**  
  - Creates one record in `purchases`.  
  - Returns the created record (with `id`).

- **`updatePurchase(String id, { DateTime? purchaseDate, String? supplierId, String? orderReference, String? notes, double? total })`**  
  - Updates the purchase by `id`; only sends non-null parameters.

- **`deletePurchase(String id)`**  
  - Loads all `purchase_items` with `purchase = "<id>"`, deletes each item, then deletes the purchase.

### 4.2 Purchase items (lines)

- **`getPurchaseItems(String purchaseId)`**  
  - Returns `List<dynamic>` of records from `purchase_items` with `purchase = "<purchaseId>"`, expand `tool`.

- **`getPurchaseItemsByTool(String toolId)`**  
  - Returns items where `tool = "<toolId>"`, expand `purchase`, `purchase.supplier`, `tool`, sort `-purchase.purchase_date`.  
  - Used by the tool edit screen for “Price over time”.

- **`createPurchaseItem({ required String purchaseId, String? toolId, required int quantity, double? unitCost, String lineType = 'item', String? description })`**  
  - Creates one line; `toolId` null for tax/shipping.  
  - Returns the created record.

- **`deletePurchaseItem(String id)`**  
  - Deletes one `purchase_items` record by id.

---

## 5. Backend Schema (PocketBase)

Defined in **`DEPLOY.md`** (§5.5). Create in Admin: **Settings → Collections**.

### 5.1 Collection: `purchases`

| Field | Type | Notes |
|-------|------|--------|
| `purchase_date` | date | Required |
| `supplier` | relation | Single → `suppliers` |
| `order_reference` | text | Optional |
| `notes` | text | Optional |
| `total` | number | Optional |

### 5.2 Collection: `purchase_items`

| Field | Type | Notes |
|-------|------|--------|
| `purchase` | relation | Single → `purchases` |
| `tool` | relation | Single → `inventory`; optional for tax/shipping |
| `quantity` | number | Required (use 1 for tax/shipping) |
| `unit_cost` | number | Optional |
| `line_type` | text | `item` (default), `tax`, or `shipping` |
| `description` | text | Optional; e.g. "GST", "PST", "Shipping" |

List/create/update/delete rules must allow the app’s auth (e.g. authenticated users).

---

## 6. Purchases List Screen (`lib/purchases_screen.dart`)

- **Widget:** `PurchasesScreen` (StatefulWidget), uses `AutoOpenDrawerMixin`, has `AppDrawer`.
- **State:** `_purchases` (list of `Purchase`), `_isLoading`.
- **On init:** `_loadPurchases()` → `PocketBaseService().getPurchases()` → map records with `Purchase.fromRecord(r)`.
- **UI:**
  - AppBar title “Purchases”, leading menu (opens drawer), `drawer: AppDrawer()`.
  - Body: top “Add Purchase” button; then either empty state or `ListView.builder` of `Card` + `ListTile`.
- **List tile:**  
  - Title: `supplierName ?? 'No supplier'`.  
  - Subtitle: date (`DateFormat.yMMMd`), optional “Ref: …”, optional “Total: $…”.  
  - Trailing chevron.  
  - **onTap:** `Navigator.push(MaterialPageRoute(builder: (context) => AddPurchaseScreen(purchase: p)))`, then `_loadPurchases()` on pop.
- **Add button onTap:** `Navigator.push(..., AddPurchaseScreen())` (no `purchase`), then `_loadPurchases()`.

So: list is read from PocketBase; add and edit both go to `AddPurchaseScreen` (edit when `purchase != null`).

---

## 7. Add/Edit Purchase Screen (`lib/add_purchase_screen.dart`)

Single full-screen form used for both **create** and **edit**.

### 7.1 Constructor and mode

- **`AddPurchaseScreen({ Purchase? purchase })`**  
  - `purchase == null` → new purchase.  
  - `purchase != null` → edit: form is pre-filled and save updates; app bar shows “Edit Purchase” and a “Delete” action.

### 7.2 State (in-memory form)

- **Header:** `_purchaseDate`, `_supplierId`, `_orderRefController`, `_notesController`, `_dateController`.
- **Line items:** `_lineItems` = `List<Map<String, dynamic>>`. Each map: `type` ('item' | 'shipping'), `toolId`, `toolName`, `quantity`, `unitCost`, `description`.
- **Tax:** `_gstChecked`, `_pstChecked`; rates `_gstRate = 0.05`, `_pstRate = 0.07`.
- **Data for dropdowns:** `_suppliers`, `_tools` (from PocketBase); `_isLoadingData`.

### 7.3 Init and load (edit mode)

- In **initState**, if `widget.purchase != null`: set `_purchaseDate`, `_supplierId`, order ref and notes text. If null, push one default line item map.
- **`_loadData()`** (async):  
  - Fetches suppliers and tools (and, in edit mode, `getPurchaseItems(widget.purchase!.id)`).  
  - In edit mode, fills `_lineItems` from items (skips `lineType == 'tax'`; sets `_gstChecked` / `_pstChecked` from tax items with description "GST"/"PST").  
  - Supplier field in edit mode uses `initialValue: TextEditingValue(text: widget.purchase!.supplierName!)` on the Autocomplete so the supplier name shows.

### 7.4 Form layout (summary)

- **Date:** TextField + calendar icon; type or pick; `_parseDateFromField()` for typed date.
- **Supplier:** `Autocomplete<Object>` over `_suppliers` (and `_SupplierNone`); selects supplier id into `_supplierId`; display uses `company_name` from supplier data.
- **Order reference, Notes:** simple TextFields.
- **Line items:**  
  - For each `_lineItems[i]`: row with type dropdown (Item / Shipping), then either:  
    - **Item:** tool `Autocomplete<Tool>`, Qty, Unit (unit cost), Subtotal (read-only from qty×unit).  
    - **Shipping:** description field + Amount.  
  - Each row has delete IconButton; last row only has “+” IconButton → `_addLine()` (appends a new line map).  
  - Subtotal/Total numeric boxes use fixed widths (e.g. 110) and `maxLines: 1` so values don’t wrap.
- **Tax row:** GST (5%) and PST (7%) checkboxes; live total; then a “Total” box (subtotal + GST + PST + shipping). Layout: `Spacer()` then GST, PST, small gap, Total(110), gap, trailing space so Total aligns under Subtotal column.
- **Actions:** “SAVE PURCHASE” (centered); in edit mode, app bar “Delete” with confirmation then `deletePurchase` and pop.

### 7.5 Save logic (`_save()`)

- **Validation:** At least one “valid” line: for type `item` → `toolId != null` and `quantity > 0`; for `shipping` → amount > 0. Tax lines are not in `_lineItems`; they’re added from checkboxes.
- **If edit:** `updatePurchase(id, ...)` then load all `getPurchaseItems(id)`, `deletePurchaseItem` each, then recreate all lines from form.
- **If create:** `createPurchase(...)`, use returned `id`.
- Then for each entry in `validLines`: `createPurchaseItem(purchaseId: id, toolId, quantity, unitCost, lineType, description)` (lineType `item` or `shipping`).
- Then if GST/PST checked: append one `createPurchaseItem` each with `lineType: 'tax'`, `description: 'GST'` or `'PST'`, `unitCost` = computed amount, `quantity: 1`, `toolId: null`.
- On success: `Navigator.pop(context)` and SnackBar “Purchase added” / “Purchase updated”.

### 7.6 Delete (`_delete()`)

- Confirmation dialog; then `PocketBaseService().deletePurchase(widget.purchase!.id)`, pop, SnackBar “Purchase deleted”.

---

## 8. Navigation and Entry Points

- **Drawer:** In `lib/app_drawer.dart`, a `ListTile` with “Purchases” and `Icons.shopping_cart` calls `Navigator.push(context, MaterialPageRoute(builder: (context) => const PurchasesScreen()))`. No named route.
- **From list:**  
  - “Add Purchase” → `AddPurchaseScreen()`.  
  - Tap a purchase → `AddPurchaseScreen(purchase: p)`.
- **Back:** Both screens use the default app bar back button; list refreshes on return via `_loadPurchases()`.

---

## 9. Integration with Tool Screen (`lib/add_tool_screen.dart`)

- **“Price over time”** (edit mode only): loads purchase history with `PocketBaseService().getPurchaseItemsByTool(widget.tool!.id)` into `_purchaseHistoryRecords`.
- Displays a table/section: date (from expanded `purchase.purchase_date`), supplier (from expanded `purchase.supplier`), quantity, unit cost, line total. So each tool can show where it was bought and at what price over time.

---

## 10. Summary for Fixes

- **List screen:** `lib/purchases_screen.dart` – load list, open add/edit.
- **Form screen:** `lib/add_purchase_screen.dart` – all form state, validation, create/update/delete and line item + GST/PST handling.
- **Data:** `lib/models.dart` (Purchase, PurchaseItem), `lib/pocketbase_service.dart` (all purchase/purchase_items calls).
- **Backend:** Two PocketBase collections as in `DEPLOY.md` §5.5; expand `supplier` on purchases and `tool` (and for tool screen `purchase`, `purchase.supplier`) on purchase_items as used in the service.
- **Navigation:** Drawer → `PurchasesScreen`; from there → `AddPurchaseScreen()` or `AddPurchaseScreen(purchase: p)`.

Fixing “the purchase screen” usually means changing `purchases_screen.dart` (list/empty state) and/or `add_purchase_screen.dart` (form layout, validation, save/load/delete). The rest of the app only depends on the public API in `pocketbase_service.dart` and the `Purchase` / `PurchaseItem` models.
