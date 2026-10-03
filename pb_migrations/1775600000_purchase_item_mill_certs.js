/// <reference path="../pb_data/types.d.ts" />
// Mill cert PDFs/images on material purchase lines (linked for Material history).

migrate((app) => {
  let items = null;
  try {
    items = app.findCollectionByNameOrId("purchase_items");
  } catch (_) {}
  if (!items) return;

  if (!items.fields.find((f) => f.name === "mill_certs")) {
    items.fields.add(
      new FileField({
        name: "mill_certs",
        maxSelect: 8,
        maxSize: 52428800,
        mimeTypes: [
          "application/pdf",
          "image/jpeg",
          "image/png",
          "image/webp",
        ],
      }),
    );
    app.save(items);
  }
}, (app) => {
  try {
    const items = app.findCollectionByNameOrId("purchase_items");
    const field = items.fields.find((f) => f.name === "mill_certs");
    if (field) {
      items.fields.removeById(field.id);
      app.save(items);
    }
  } catch (_) {}
});
