/// <reference path="../pb_data/types.d.ts" />
// Job → purchase line link for material heat/lot + mill cert PDFs.

migrate((app) => {
  let jobs = null;
  try {
    jobs = app.findCollectionByNameOrId("jobs");
  } catch (_) {}
  if (!jobs) return;

  let items = null;
  try {
    items = app.findCollectionByNameOrId("purchase_items");
  } catch (_) {}
  if (!items) return;

  if (!jobs.fields.find((f) => f.name === "material_purchase_item")) {
    jobs.fields.add(
      new RelationField({
        name: "material_purchase_item",
        collectionId: items.id,
        maxSelect: 1,
        required: false,
      }),
    );
    app.save(jobs);
  }
}, (app) => {
  try {
    const jobs = app.findCollectionByNameOrId("jobs");
    const field = jobs.fields.find((f) => f.name === "material_purchase_item");
    if (field) {
      jobs.fields.removeById(field.id);
      app.save(jobs);
    }
  } catch (_) {}
});
