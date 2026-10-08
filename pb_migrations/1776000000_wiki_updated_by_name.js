/// <reference path="../pb_data/types.d.ts" />
migrate(
  (app) => {
    const wiki = app.findCollectionByNameOrId("wiki_pages");
    if (!wiki) return;

    if (!wiki.fields.find((f) => f.name === "updated_by_name")) {
      wiki.fields.add(
        new Field({
          type: "text",
          name: "updated_by_name",
          required: false,
          max: 200,
        }),
      );
      app.save(wiki);
    }
  },
  (app) => {
    const wiki = app.findCollectionByNameOrId("wiki_pages");
    if (!wiki) return;
    const field = wiki.fields.find((f) => f.name === "updated_by_name");
    if (field) {
      wiki.fields.removeById(field.id);
      app.save(wiki);
    }
  },
);
