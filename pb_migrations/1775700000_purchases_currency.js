/// <reference path="../pb_data/types.d.ts" />
// Purchase currency tag (CAD default, USD for McMaster / USD Visa — no FX).

migrate((app) => {
  let purchases = null;
  try {
    purchases = app.findCollectionByNameOrId("purchases");
  } catch (_) {}
  if (!purchases) return;

  if (!purchases.fields.find((f) => f.name === "currency")) {
    purchases.fields.add(
      new SelectField({
        name: "currency",
        required: false,
        maxSelect: 1,
        values: ["CAD", "USD"],
      }),
    );
    app.save(purchases);
  }
}, (app) => {
  try {
    const purchases = app.findCollectionByNameOrId("purchases");
    const field = purchases.fields.find((f) => f.name === "currency");
    if (field) {
      purchases.fields.removeById(field.id);
      app.save(purchases);
    }
  } catch (_) {}
});
