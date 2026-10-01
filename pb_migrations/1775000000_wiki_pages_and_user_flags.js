/// <reference path="../pb_data/types.d.ts" />
// Wiki pages (tree + markdown) and user flags for owner-only / read-only.

migrate((app) => {
  const usersCollection = app.findCollectionByNameOrId("users");
  if (usersCollection) {
    if (!usersCollection.fields.find((f) => f.name === "wiki_owner")) {
      usersCollection.fields.add(
        new BoolField({
          name: "wiki_owner",
          required: false,
        }),
      );
    }
    if (!usersCollection.fields.find((f) => f.name === "wiki_readonly")) {
      usersCollection.fields.add(
        new BoolField({
          name: "wiki_readonly",
          required: false,
        }),
      );
    }
    app.save(usersCollection);
  }

  const viewRule =
    '@request.auth.id != "" && (visibility = "everyone" || (visibility = "staff" && @request.auth.role != "jobs_only") || (visibility = "owner" && @request.auth.wiki_owner = true))';
  const writeRule =
    '@request.auth.id != "" && @request.auth.wiki_readonly != true && (visibility = "everyone" || (visibility = "staff" && @request.auth.role != "jobs_only") || (visibility = "owner" && @request.auth.wiki_owner = true))';
  const createRule =
    '@request.auth.id != "" && @request.auth.wiki_readonly != true';

  let wiki = null;
  try {
    wiki = app.findCollectionByNameOrId("wiki_pages");
  } catch (_) {}

  if (!wiki) {
    wiki = new Collection({
      name: "wiki_pages",
      type: "base",
      listRule: viewRule,
      viewRule: viewRule,
      createRule: createRule,
      updateRule: writeRule,
      deleteRule: writeRule,
    });
  }

  const addIfMissing = (field) => {
    if (!wiki.fields.find((f) => f.name === field.name)) {
      wiki.fields.add(field);
    }
  };

  addIfMissing(
    new TextField({
      name: "title",
      required: true,
    }),
  );
  addIfMissing(
    new TextField({
      name: "body",
    }),
  );
  addIfMissing(
    new SelectField({
      name: "visibility",
      required: true,
      values: ["everyone", "staff", "owner"],
    }),
  );
  addIfMissing(
    new NumberField({
      name: "sort_order",
    }),
  );
  addIfMissing(
    new TextField({
      name: "updated_by_email",
    }),
  );
  addIfMissing(
    new FileField({
      name: "attachments",
      maxSelect: 12,
      maxSize: 52428800,
      mimeTypes: [
        "image/jpeg",
        "image/png",
        "image/gif",
        "image/webp",
        "application/pdf",
      ],
    }),
  );

  app.save(wiki);

  const saved = app.findCollectionByNameOrId("wiki_pages");
  if (!saved.fields.find((f) => f.name === "parent")) {
    saved.fields.add(
      new RelationField({
        name: "parent",
        collectionId: saved.id,
        maxSelect: 1,
        required: false,
      }),
    );
    app.save(saved);
  }
}, (app) => {
  try {
    const wiki = app.findCollectionByNameOrId("wiki_pages");
    app.delete(wiki);
  } catch (_) {}

  const usersCollection = app.findCollectionByNameOrId("users");
  if (usersCollection) {
    for (const name of ["wiki_owner", "wiki_readonly"]) {
      const field = usersCollection.fields.find((f) => f.name === name);
      if (field) {
        usersCollection.fields.removeById(field.id);
      }
    }
    app.save(usersCollection);
  }
});
