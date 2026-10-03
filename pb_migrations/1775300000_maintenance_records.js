/// <reference path="../pb_data/types.d.ts" />
// Shop maintenance records + expandable machines list. Any logged-in user can CRUD.
// Note: do not seed with findRecordsByFilter(..., "-created") — older PB rejects that sort.

migrate((app) => {
  const authRule = '@request.auth.id != ""';

  let machines = null;
  try {
    machines = app.findCollectionByNameOrId("maintenance_machines");
  } catch (_) {}

  if (!machines) {
    machines = new Collection({
      name: "maintenance_machines",
      type: "base",
      listRule: authRule,
      viewRule: authRule,
      createRule: authRule,
      updateRule: authRule,
      deleteRule: authRule,
    });
  }

  const addMachineField = (field) => {
    if (!machines.fields.find((f) => f.name === field.name)) {
      machines.fields.add(field);
    }
  };

  addMachineField(
    new TextField({
      name: "name",
      required: true,
    }),
  );
  addMachineField(
    new NumberField({
      name: "sort_order",
    }),
  );

  app.save(machines);

  const machinesCol = app.findCollectionByNameOrId("maintenance_machines");

  let records = null;
  try {
    records = app.findCollectionByNameOrId("maintenance_records");
  } catch (_) {}

  if (!records) {
    records = new Collection({
      name: "maintenance_records",
      type: "base",
      listRule: authRule,
      viewRule: authRule,
      createRule: authRule,
      updateRule: authRule,
      deleteRule: authRule,
    });
  }

  const addRecordField = (field) => {
    if (!records.fields.find((f) => f.name === field.name)) {
      records.fields.add(field);
    }
  };

  addRecordField(
    new TextField({
      name: "name",
      required: true,
    }),
  );
  addRecordField(
    new DateField({
      name: "completed_date",
      required: false,
    }),
  );
  addRecordField(
    new RelationField({
      name: "machine",
      collectionId: machinesCol.id,
      maxSelect: 1,
      required: true,
    }),
  );
  addRecordField(
    new TextField({
      name: "note",
    }),
  );
  addRecordField(
    new TextField({
      name: "updated_by_email",
    }),
  );

  app.save(records);

  // Seed starter machines only if none exist. Empty sort (no "-created") for PB compat.
  let existing = [];
  try {
    existing = app.findRecordsByFilter("maintenance_machines", "", "", 1, 0);
  } catch (_) {
    existing = [];
  }
  if (!existing || existing.length === 0) {
    const seed = [
      { name: "DMU65", sort_order: 10 },
      { name: "Kaeser", sort_order: 20 },
      { name: "Airwash", sort_order: 30 },
      { name: "X1C #1", sort_order: 40 },
    ];
    for (const row of seed) {
      const rec = new Record(machinesCol);
      rec.set("name", row.name);
      rec.set("sort_order", row.sort_order);
      app.save(rec);
    }
  }
}, (app) => {
  try {
    const records = app.findCollectionByNameOrId("maintenance_records");
    app.delete(records);
  } catch (_) {}
  try {
    const machines = app.findCollectionByNameOrId("maintenance_machines");
    app.delete(machines);
  } catch (_) {}
});
