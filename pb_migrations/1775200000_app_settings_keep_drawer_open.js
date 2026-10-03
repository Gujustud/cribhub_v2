/// <reference path="../pb_data/types.d.ts" />
// Ensure app_settings.keep_drawer_open exists (desktop pinned side menu).

migrate((app) => {
  let collection;
  try {
    collection = app.findCollectionByNameOrId("app_settings");
  } catch (_) {
    return;
  }

  if (!collection.fields.find((f) => f.name === "keep_drawer_open")) {
    collection.fields.add(
      new BoolField({
        name: "keep_drawer_open",
        required: false,
      }),
    );
    app.save(collection);
  }
}, (app) => {
  let collection;
  try {
    collection = app.findCollectionByNameOrId("app_settings");
  } catch (_) {
    return;
  }

  const field = collection.fields.find((f) => f.name === "keep_drawer_open");
  if (field) {
    collection.fields.removeById(field.id);
    app.save(collection);
  }
});
