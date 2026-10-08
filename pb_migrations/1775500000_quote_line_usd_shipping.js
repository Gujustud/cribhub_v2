/// <reference path="../pb_data/types.d.ts" />
// Optional USD material shipping on quote line items (CAD still material_shipping_cost).

migrate((app) => {
  const col = app.findCollectionByNameOrId("quote_line_items");
  if (!col) return;
  if (!col.fields.find((f) => f.name === "usd_shipping_cost")) {
    col.fields.add(
      new NumberField({
        name: "usd_shipping_cost",
        required: false,
      }),
    );
    app.save(col);
  }
}, (app) => {
  try {
    const col = app.findCollectionByNameOrId("quote_line_items");
    const field = col.fields.find((f) => f.name === "usd_shipping_cost");
    if (field) {
      col.fields.removeById(field.id);
      app.save(col);
    }
  } catch (_) {}
});
