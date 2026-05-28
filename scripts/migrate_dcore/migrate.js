/**
 * Copy DharmaCore PocketBase ERP collections into erp-dev Cribhub PocketBase.
 *
 * Maps vendors → suppliers (merge by company_name). Remaps all relation IDs.
 * Optionally copies part_images files on quotes and jobs.
 *
 * Usage:
 *   cp .env.example .env   # fill credentials
 *   npm install
 *   npm run migrate
 *   npm run dry-run
 */

import PocketBase from 'pocketbase';
import { readFileSync, existsSync } from 'fs';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

// ---------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------

function loadEnvFile() {
  const envPath = resolve(__dirname, '.env');
  if (!existsSync(envPath)) return;
  for (const line of readFileSync(envPath, 'utf8').split('\n')) {
    const t = line.trim();
    if (!t || t.startsWith('#')) continue;
    const i = t.indexOf('=');
    if (i < 0) continue;
    const key = t.slice(0, i).trim();
    let val = t.slice(i + 1).trim();
    if (
      (val.startsWith('"') && val.endsWith('"')) ||
      (val.startsWith("'") && val.endsWith("'"))
    ) {
      val = val.slice(1, -1);
    }
    if (process.env[key] === undefined) process.env[key] = val;
  }
}

loadEnvFile();

const args = process.argv.slice(2);
const DRY_RUN = args.includes('--dry-run');

const DCORE_URL = (process.env.DCORE_PB_URL || 'http://192.168.20.103:8090/').replace(
  /\/?$/,
  '/',
);
const TARGET_URL = (process.env.TARGET_PB_URL || 'http://192.168.20.104:8091/').replace(
  /\/?$/,
  '/',
);
const DCORE_EMAIL = process.env.DCORE_ADMIN_EMAIL || '';
const DCORE_PASSWORD = process.env.DCORE_ADMIN_PASSWORD || '';
const TARGET_EMAIL = process.env.TARGET_ADMIN_EMAIL || '';
const TARGET_PASSWORD = process.env.TARGET_ADMIN_PASSWORD || '';
const WIPE = process.env.WIPE_ERP_BEFORE_IMPORT === '1';

const SETTINGS_FIELDS = [
  'default_shipping_markup_percent',
  'default_final_markup_percent',
  'default_hourly_rate_programming',
  'default_hourly_rate_setup',
  'default_hourly_rate_first_run',
  'default_hourly_rate_production',
  'exchange_rate_usd_to_cad',
  'exchange_rate_auto_update',
  'exchange_rate_last_updated',
  'auto_logout_minutes',
];

const CUSTOMER_FIELDS = ['company', 'name', 'email', 'phone', 'address', 'notes'];

const QUOTE_FIELDS = [
  'job_number',
  'wave_quote_number',
  'customer',
  'customer_name',
  'po_number',
  'engineer',
  'status',
  'shipping_markup_percent',
  'final_markup_percent',
  'subcontractor_markup_percent',
  'exchange_rate_usd_to_cad',
  'hourly_rate_programming',
  'hourly_rate_setup',
  'hourly_rate_first_run',
  'hourly_rate_production',
  'materials_total',
  'tooling_total',
  'labor_total',
  'subcontractor_total',
  'subtotal',
  'final_total_cad',
  'final_total_usd',
  'notes',
  'actual_time_notes',
];

const LINE_ITEM_FIELDS = [
  'quote',
  'line_number',
  'part_number',
  'part_quantity',
  'alloy',
  'stock_size_per_part',
  'ordered_length',
  'pieces',
  'material_note',
  'material_vendor',
  'vendor_supplied',
  'usd_cost',
  'material_cost_cad',
  'material_shipping_cost',
  'testing_cost',
  'tooling_total_cost',
  'tooling_description',
  'programming_hours',
  'setup_hours',
  'first_run_hours',
  'production_hours_total',
  'labor_note',
  'subcontractor_1',
  'subcontractor_1_service',
  'subcontractor_1_cost',
  'subcontractor_1_shipping',
  'subcontractor_2',
  'subcontractor_2_service',
  'subcontractor_2_cost',
  'subcontractor_2_shipping',
  'heat_treat_cost',
  'inspection_cost',
  'packaging_cost',
  'shipping_cost',
  'previous_quote_reference',
  'material_actual_cost_cad',
  'material_with_markup',
  'labor_cost',
  'subcontractor_1_total',
  'subcontractor_2_total',
  'line_total_cad',
  'price_per_part_cad',
  'price_per_part_usd',
  'quoted_price_per_part_cad',
  'quoted_price_per_part_usd',
  'quote_part_price_cad',
];

const JOB_FIELDS = [
  'quote',
  'job_number',
  'customer',
  'customer_name',
  'parts_description',
  'status',
  'due_date',
  'completion_date',
  'ship_date',
  'delivered_date',
  'tracking_status',
  'tracking_number_1',
  'tracking_link_1',
  'tracking_number_2',
  'tracking_link_2',
  'wave_invoice_number',
  'po_number',
  'material_lot',
  'material_source',
  'material_source_vendor',
  'material_notes',
  'project_notes',
  'notes',
];

const stats = {
  settings: { updated: 0, created: 0 },
  suppliers: { created: 0, mapped: 0 },
  customers: { created: 0, skipped: 0 },
  quotes: { created: 0, skipped: 0 },
  lineItems: { created: 0, skipped: 0 },
  jobs: { created: 0, skipped: 0 },
  files: { copied: 0, failed: 0 },
  errors: [],
};

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function log(msg) {
  console.log(msg);
}

function warn(msg) {
  console.warn(`WARN: ${msg}`);
}

function normName(s) {
  return (s == null ? '' : String(s)).toLowerCase().replace(/\s+/g, ' ').trim();
}

function pick(record, fields) {
  const out = {};
  for (const f of fields) {
    if (record[f] !== undefined && record[f] !== null && record[f] !== '') {
      out[f] = record[f];
    }
  }
  return out;
}

function relationId(v) {
  if (v == null || v === '') return null;
  if (typeof v === 'string') return v;
  if (typeof v === 'object' && v.id) return v.id;
  return null;
}

async function getAllRecords(pb, collection, options = {}) {
  const items = [];
  let page = 1;
  const perPage = 200;
  while (true) {
    const res = await pb.collection(collection).getList(page, perPage, options);
    items.push(...res.items);
    if (page >= res.totalPages) break;
    page += 1;
  }
  return items;
}

async function authAdmin(pb, email, password, label) {
  if (!email || !password) {
    throw new Error(`${label}: set admin email and password in .env`);
  }
  try {
    await pb.admins.authWithPassword(email, password);
  } catch (e) {
    // PocketBase admin auth endpoint differs across versions (or can be disabled).
    // When we get a 404, fall back to regular user authentication.
    if (e?.response?.status === 404) {
      console.warn(
        `${label}: admin auth endpoint not found (404). Falling back to users.authWithPassword.`,
      );
      try {
        await pb.collection('users').authWithPassword(email, password);
        return;
      } catch (e2) {
        console.error(`Auth failed (${label}) via users auth fallback`, {
          email,
          passwordLength: password?.length,
          errorMessage: e2?.message,
          responseStatus: e2?.response?.status,
          responseData: e2?.response?.data,
          rawError: e2,
        });
        throw e2;
      }
    }
    // Avoid printing password; include enough context to diagnose the PocketBase auth failure.
    console.error(`Auth failed (${label})`, {
      email,
      passwordLength: password?.length,
      errorMessage: e?.message,
      errorStack: e?.stack,
      errorKeys: e ? Object.keys(e) : [],
      responseStatus: e?.response?.status,
      responseData: e?.response?.data,
      responseText: e?.response?.text,
      rawError: e,
    });
    throw e;
  }
}

async function fileBlob(sourcePb, collectionName, record, filename) {
  const url = sourcePb.files.getUrl(record, filename);
  const headers = {};
  if (sourcePb.authStore.token) {
    headers.Authorization = sourcePb.authStore.token;
  }
  const res = await fetch(url, { headers });
  if (!res.ok) {
    throw new Error(`HTTP ${res.status} fetching ${filename}`);
  }
  return res.blob();
}

function normalizeFilenames(field) {
  if (field == null) return [];
  if (Array.isArray(field)) return field.filter(Boolean);
  return [String(field)];
}

async function copyPartImages(sourcePb, targetPb, collectionName, sourceRecord, targetId) {
  const names = normalizeFilenames(sourceRecord.part_images);
  if (names.length === 0) return;

  for (const filename of names) {
    try {
      if (DRY_RUN) {
        stats.files.copied += 1;
        continue;
      }
      const blob = await fileBlob(sourcePb, collectionName, sourceRecord, filename);
      const form = new FormData();
      form.append('part_images+', blob, filename);
      await targetPb.collection(collectionName).update(targetId, form);
      stats.files.copied += 1;
    } catch (e) {
      stats.files.failed += 1;
      warn(`File ${collectionName}/${targetId}/${filename}: ${e.message}`);
    }
  }
}

// ---------------------------------------------------------------------------
// Migration steps
// ---------------------------------------------------------------------------

async function wipeErp(target) {
  const order = ['quote_line_items', 'jobs', 'quotes', 'customers'];
  for (const col of order) {
    const rows = await getAllRecords(target, col);
    log(`  Wiping ${col}: ${rows.length} records`);
    if (DRY_RUN) continue;
    for (const row of rows) {
      await target.collection(col).delete(row.id);
    }
  }
}

async function migrateSettings(source, target) {
  log('\n--- settings ---');
  let src;
  try {
    const list = await getAllRecords(source, 'settings');
    src = list[0];
  } catch (e) {
    warn(`No settings on source: ${e.message}`);
    return;
  }
  if (!src) {
    warn('Source settings empty');
    return;
  }

  const body = pick(src, SETTINGS_FIELDS);
  let tgtList = [];
  try {
    tgtList = await getAllRecords(target, 'settings');
  } catch (_) {}

  if (DRY_RUN) {
    log(`  Would upsert settings (${Object.keys(body).length} fields)`);
    return;
  }

  if (tgtList.length > 0) {
    await target.collection('settings').update(tgtList[0].id, body);
    stats.settings.updated += 1;
    log('  Updated existing settings row');
  } else {
    await target.collection('settings').create(body);
    stats.settings.created += 1;
    log('  Created settings row');
  }
}

async function migrateSuppliers(source, target, vendorToSupplier) {
  log('\n--- vendors → suppliers ---');
  const vendors = await getAllRecords(source, 'vendors');
  const existing = await getAllRecords(target, 'suppliers');
  const byName = new Map();
  for (const s of existing) {
    byName.set(normName(s.company_name), s);
  }

  for (const v of vendors) {
    const companyName = (v.name || '').trim() || `Vendor ${v.id}`;
    const key = normName(companyName);
    if (byName.has(key)) {
      vendorToSupplier.set(v.id, byName.get(key).id);
      stats.suppliers.mapped += 1;
      continue;
    }

    const body = {
      company_name: companyName.slice(0, 100),
      contact: v.contact_person || undefined,
      email: v.email || undefined,
      tel: v.phone || undefined,
      address: [v.services, v.notes].filter(Boolean).join('\n').trim() || undefined,
    };

    if (DRY_RUN) {
      vendorToSupplier.set(v.id, `dry-run-supplier-${v.id}`);
      stats.suppliers.created += 1;
      continue;
    }

    try {
      const created = await target.collection('suppliers').create(body);
      vendorToSupplier.set(v.id, created.id);
      byName.set(key, created);
      stats.suppliers.created += 1;
    } catch (e) {
      stats.errors.push(`supplier ${companyName}: ${e.message}`);
      warn(`supplier ${companyName}: ${e.message}`);
    }
  }
  log(
    `  vendors=${vendors.length} created=${stats.suppliers.created} mapped_existing=${stats.suppliers.mapped}`,
  );
}

async function migrateCustomers(source, target, customerMap) {
  log('\n--- customers ---');
  const customers = await getAllRecords(source, 'customers');
  const existing = await getAllRecords(target, 'customers');
  const byCompany = new Map();
  for (const c of existing) {
    const key = normName(c.company || c.name || '');
    if (key) byCompany.set(key, c);
  }

  for (const c of customers) {
    const company = (c.company || c.name || '').trim() || 'Unknown';
    const key = normName(company);
    if (byCompany.has(key)) {
      customerMap.set(c.id, byCompany.get(key).id);
      stats.customers.skipped += 1;
      continue;
    }

    const body = {
      company,
      ...pick(c, CUSTOMER_FIELDS.filter((f) => f !== 'company')),
    };

    if (DRY_RUN) {
      customerMap.set(c.id, `dry-run-customer-${c.id}`);
      stats.customers.created += 1;
      continue;
    }

    try {
      const created = await target.collection('customers').create(body);
      customerMap.set(c.id, created.id);
      byCompany.set(key, created);
      stats.customers.created += 1;
    } catch (e) {
      stats.errors.push(`customer ${company}: ${e.message}`);
      warn(`customer ${company}: ${e.message}`);
    }
  }
  log(
    `  source=${customers.length} created=${stats.customers.created} matched_existing=${stats.customers.skipped}`,
  );
}

async function migrateQuotes(
  source,
  target,
  customerMap,
  vendorToSupplier,
  quoteMap,
) {
  log('\n--- quotes ---');
  const quotes = await getAllRecords(source, 'quotes');
  const existing = await getAllRecords(target, 'quotes');
  const byJob = new Set(existing.map((q) => q.job_number));

  for (const q of quotes) {
    if (byJob.has(q.job_number)) {
      stats.quotes.skipped += 1;
      const match = existing.find((x) => x.job_number === q.job_number);
      if (match) quoteMap.set(q.id, match.id);
      continue;
    }

    const body = pick(q, QUOTE_FIELDS.filter((f) => f !== 'customer'));
    const oldCust = relationId(q.customer);
    if (oldCust && customerMap.has(oldCust)) {
      body.customer = customerMap.get(oldCust);
    }

    if (DRY_RUN) {
      quoteMap.set(q.id, `dry-run-quote-${q.id}`);
      stats.quotes.created += 1;
      continue;
    }

    try {
      const created = await target.collection('quotes').create(body);
      quoteMap.set(q.id, created.id);
      byJob.add(q.job_number);
      stats.quotes.created += 1;
      await copyPartImages(source, target, 'quotes', q, created.id);
    } catch (e) {
      stats.errors.push(`quote ${q.job_number}: ${e.message}`);
      warn(`quote ${q.job_number}: ${e.message}`);
    }
  }
  log(
    `  source=${quotes.length} created=${stats.quotes.created} skipped_duplicate_job=${stats.quotes.skipped}`,
  );
}

async function migrateLineItems(source, target, quoteMap, vendorToSupplier) {
  log('\n--- quote_line_items ---');
  const items = await getAllRecords(source, 'quote_line_items', { sort: 'line_number' });

  for (const item of items) {
    const oldQuote = relationId(item.quote);
    if (!oldQuote || !quoteMap.has(oldQuote)) {
      stats.lineItems.skipped += 1;
      continue;
    }

    const body = pick(item, LINE_ITEM_FIELDS.filter((f) => f !== 'quote'));
    body.quote = quoteMap.get(oldQuote);

    for (const rel of ['material_vendor', 'subcontractor_1', 'subcontractor_2']) {
      const oldV = relationId(item[rel]);
      if (oldV && vendorToSupplier.has(oldV)) {
        body[rel] = vendorToSupplier.get(oldV);
      } else {
        delete body[rel];
      }
    }

    if (DRY_RUN) {
      stats.lineItems.created += 1;
      continue;
    }

    try {
      await target.collection('quote_line_items').create(body);
      stats.lineItems.created += 1;
    } catch (e) {
      stats.lineItems.skipped += 1;
      const jn = item.part_number || item.line_number;
      stats.errors.push(`line item ${jn}: ${e.message}`);
      warn(`line item ${jn}: ${e.message}`);
    }
  }
  log(
    `  source=${items.length} created=${stats.lineItems.created} skipped=${stats.lineItems.skipped}`,
  );
}

async function migrateJobs(source, target, quoteMap, customerMap, vendorToSupplier, jobMap) {
  log('\n--- jobs ---');
  const jobs = await getAllRecords(source, 'jobs');
  const existing = await getAllRecords(target, 'jobs');
  const byJobNum = new Map(existing.map((j) => [j.job_number, j]));

  for (const j of jobs) {
    if (byJobNum.has(j.job_number)) {
      stats.jobs.skipped += 1;
      jobMap.set(j.id, byJobNum.get(j.job_number).id);
      continue;
    }

    const body = pick(j, JOB_FIELDS.filter((f) => !['quote', 'customer', 'material_source_vendor'].includes(f)));

    const oldQuote = relationId(j.quote);
    if (!oldQuote || !quoteMap.has(oldQuote)) {
      stats.jobs.skipped += 1;
      warn(`job ${j.job_number}: missing quote mapping`);
      continue;
    }
    body.quote = quoteMap.get(oldQuote);

    const oldCust = relationId(j.customer);
    if (oldCust && customerMap.has(oldCust)) {
      body.customer = customerMap.get(oldCust);
    }

    const oldVendor = relationId(j.material_source_vendor);
    if (oldVendor && vendorToSupplier.has(oldVendor)) {
      body.material_source_vendor = vendorToSupplier.get(oldVendor);
    }

    if (DRY_RUN) {
      jobMap.set(j.id, `dry-run-job-${j.id}`);
      stats.jobs.created += 1;
      continue;
    }

    try {
      const created = await target.collection('jobs').create(body);
      jobMap.set(j.id, created.id);
      byJobNum.set(j.job_number, created);
      stats.jobs.created += 1;
      await copyPartImages(source, target, 'jobs', j, created.id);
    } catch (e) {
      stats.jobs.skipped += 1;
      stats.errors.push(`job ${j.job_number}: ${e.message}`);
      warn(`job ${j.job_number}: ${e.message}`);
    }
  }
  log(
    `  source=${jobs.length} created=${stats.jobs.created} skipped=${stats.jobs.skipped}`,
  );
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  log('=== DharmaCore → erp-dev PocketBase migration ===');
  log(`Mode: ${DRY_RUN ? 'DRY RUN' : 'LIVE'}`);
  log(`Source: ${DCORE_URL}`);
  log(`Target: ${TARGET_URL}`);

  const source = new PocketBase(DCORE_URL);
  const target = new PocketBase(TARGET_URL);

  log('\nAuthenticating...');
  await authAdmin(source, DCORE_EMAIL, DCORE_PASSWORD, 'DCORE');
  await authAdmin(target, TARGET_EMAIL, TARGET_PASSWORD, 'TARGET');
  log('OK');

  if (WIPE) {
    log('\n--- Wiping target ERP collections ---');
    await wipeErp(target);
  }

  const vendorToSupplier = new Map();
  const customerMap = new Map();
  const quoteMap = new Map();
  const jobMap = new Map();

  await migrateSettings(source, target);
  await migrateSuppliers(source, target, vendorToSupplier);
  await migrateCustomers(source, target, customerMap);
  await migrateQuotes(source, target, customerMap, vendorToSupplier, quoteMap);
  await migrateLineItems(source, target, quoteMap, vendorToSupplier);
  await migrateJobs(source, target, quoteMap, customerMap, vendorToSupplier, jobMap);

  log('\n=== Summary ===');
  log(JSON.stringify(stats, null, 2));
  if (stats.errors.length > 0) {
    log(`\n${stats.errors.length} error(s) — see WARN lines above`);
    process.exitCode = 1;
  }
}

main().catch((e) => {
  console.error('Fatal:', {
    message: e?.message,
    stack: e?.stack,
    keys: e ? Object.keys(e) : [],
    responseStatus: e?.response?.status,
    responseData: e?.response?.data,
    rawError: e,
  });
  process.exit(1);
});
