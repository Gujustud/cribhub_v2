/// <reference path="../pb_data/types.d.ts" />
// Recurring maintenance schedules. Mark-done writes a log row + advances next_due_date.
// Any logged-in user can CRUD (same as maintenance_records).

migrate((app) => {
  const authRule = '@request.auth.id != ""';

  const machinesCol = app.findCollectionByNameOrId("maintenance_machines");
  if (!machinesCol) {
    throw new Error("maintenance_machines missing — apply 1775300000 first");
  }

  let schedules = null;
  try {
    schedules = app.findCollectionByNameOrId("maintenance_schedules");
  } catch (_) {}

  if (!schedules) {
    schedules = new Collection({
      name: "maintenance_schedules",
      type: "base",
      listRule: authRule,
      viewRule: authRule,
      createRule: authRule,
      updateRule: authRule,
      deleteRule: authRule,
    });
  }

  const addIfMissing = (col, field) => {
    if (!col.fields.find((f) => f.name === field.name)) {
      col.fields.add(field);
    }
  };

  addIfMissing(
    schedules,
    new TextField({
      name: "name",
      required: true,
    }),
  );
  addIfMissing(
    schedules,
    new RelationField({
      name: "machine",
      collectionId: machinesCol.id,
      maxSelect: 1,
      required: true,
    }),
  );
  addIfMissing(
    schedules,
    new NumberField({
      name: "frequency_value",
      required: true,
    }),
  );
  addIfMissing(
    schedules,
    new SelectField({
      name: "frequency_unit",
      required: true,
      values: ["days", "weeks", "months"],
    }),
  );
  addIfMissing(
    schedules,
    new DateField({
      name: "next_due_date",
      required: true,
    }),
  );
  addIfMissing(
    schedules,
    new DateField({
      name: "last_completed_date",
      required: false,
    }),
  );
  addIfMissing(
    schedules,
    new BoolField({
      name: "active",
      required: false,
    }),
  );
  addIfMissing(
    schedules,
    new NumberField({
      name: "lead_days",
    }),
  );
  addIfMissing(
    schedules,
    new TextField({
      name: "note",
    }),
  );
  addIfMissing(
    schedules,
    new TextField({
      name: "updated_by_email",
    }),
  );

  app.save(schedules);

  const schedulesCol = app.findCollectionByNameOrId("maintenance_schedules");

  // Optional link from log rows back to the schedule that produced them.
  const records = app.findCollectionByNameOrId("maintenance_records");
  if (records && !records.fields.find((f) => f.name === "schedule")) {
    records.fields.add(
      new RelationField({
        name: "schedule",
        collectionId: schedulesCol.id,
        maxSelect: 1,
        required: false,
      }),
    );
    app.save(records);
  }
}, (app) => {
  try {
    const records = app.findCollectionByNameOrId("maintenance_records");
    const field = records.fields.find((f) => f.name === "schedule");
    if (field) {
      records.fields.removeById(field.id);
      app.save(records);
    }
  } catch (_) {}
  try {
    const schedules = app.findCollectionByNameOrId("maintenance_schedules");
    app.delete(schedules);
  } catch (_) {}
});
