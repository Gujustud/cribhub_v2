/// <reference path="../pb_data/types.d.ts" />
// Materials catalog + purchase line link + mill cert PDFs on purchases.

migrate((app) => {
  const authRule = '@request.auth.id != ""';

  let materials = null;
  try {
    materials = app.findCollectionByNameOrId("materials");
  } catch (_) {}

  if (!materials) {
    materials = new Collection({
      name: "materials",
      type: "base",
      listRule: authRule,
      viewRule: authRule,
      createRule: authRule,
      updateRule: authRule,
      deleteRule: authRule,
    });
  }

  const addMaterialField = (field) => {
    if (!materials.fields.find((f) => f.name === field.name)) {
      materials.fields.add(field);
    }
  };

  addMaterialField(
    new TextField({
      name: "grade",
      required: true,
    }),
  );
  addMaterialField(
    new SelectField({
      name: "form",
      required: true,
      values: ["bar", "plate", "sheet", "tube", "hex", "flat", "other"],
    }),
  );
  addMaterialField(
    new TextField({
      name: "size_label",
      required: true,
    }),
  );
  addMaterialField(
    new SelectField({
      name: "unit",
      required: false,
      values: ["ea", "ft", "in", "lb", "kg"],
    }),
  );
  addMaterialField(
    new TextField({
      name: "notes",
    }),
  );

  app.save(materials);
  const materialsCol = app.findCollectionByNameOrId("materials");

  let items = null;
  try {
    items = app.findCollectionByNameOrId("purchase_items");
  } catch (_) {}

  if (items) {
    if (!items.fields.find((f) => f.name === "material")) {
      items.fields.add(
        new RelationField({
          name: "material",
          collectionId: materialsCol.id,
          maxSelect: 1,
          required: false,
        }),
      );
    }
    if (!items.fields.find((f) => f.name === "heat_lot")) {
      items.fields.add(
        new TextField({
          name: "heat_lot",
        }),
      );
    }
    app.save(items);
  }

  let purchases = null;
  try {
    purchases = app.findCollectionByNameOrId("purchases");
  } catch (_) {}

  if (purchases) {
    if (!purchases.fields.find((f) => f.name === "attachments")) {
      purchases.fields.add(
        new FileField({
          name: "attachments",
          maxSelect: 12,
          maxSize: 52428800,
          mimeTypes: ["application/pdf", "image/jpeg", "image/png", "image/webp"],
        }),
      );
    }
    app.save(purchases);
  }
}, (app) => {
  try {
    const purchases = app.findCollectionByNameOrId("purchases");
    const att = purchases.fields.find((f) => f.name === "attachments");
    if (att) {
      purchases.fields.removeById(att.id);
      app.save(purchases);
    }
  } catch (_) {}

  try {
    const items = app.findCollectionByNameOrId("purchase_items");
    for (const name of ["material", "heat_lot"]) {
      const field = items.fields.find((f) => f.name === name);
      if (field) items.fields.removeById(field.id);
    }
    app.save(items);
  } catch (_) {}

  try {
    const materials = app.findCollectionByNameOrId("materials");
    app.delete(materials);
  } catch (_) {}
});
