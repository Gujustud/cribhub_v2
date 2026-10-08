/// <reference path="../pb_data/types.d.ts" />
// Optional supplier invoice number on purchases (alongside order_reference).

migrate((app) => {
  let purchases = null;
  try {
    purchases = app.findCollectionByNameOrId("purchases");
  } catch (_) {}
  if (!purchases) return;

  if (!purchases.fields.find((f) => f.name === "invoice")) {
    purchases.fields.add(
      new TextField({
        name: "invoice",
        required: false,
      }),
    );
    app.save(purchases);
  }
}, (app) => {
  try {
    const purchases = app.findCollectionByNameOrId("purchases");
    const field = purchases.fields.find((f) => f.name === "invoice");
    if (field) {
      purchases.fields.removeById(field.id);
      app.save(purchases);
    }
  } catch (_) {}
});
