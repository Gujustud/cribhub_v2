/// <reference path="../pb_data/types.d.ts" />
// Reusable wiki tables: schema (columns JSON) + rows (values JSON).
// Embed in a wiki page body with {{table:RECORD_ID}}.

migrate((app) => {
  const authRule = '@request.auth.id != ""';
  const writeRule =
    '@request.auth.id != "" && @request.auth.wiki_readonly != true';

  let wikiPages = null;
  try {
    wikiPages = app.findCollectionByNameOrId("wiki_pages");
  } catch (_) {}

  let tables = null;
  try {
    tables = app.findCollectionByNameOrId("wiki_tables");
  } catch (_) {}

  if (!tables) {
    tables = new Collection({
      name: "wiki_tables",
      type: "base",
      listRule: authRule,
      viewRule: authRule,
      createRule: writeRule,
      updateRule: writeRule,
      deleteRule: writeRule,
    });
  }

  const addTableField = (field) => {
    if (!tables.fields.find((f) => f.name === field.name)) {
      tables.fields.add(field);
    }
  };

  addTableField(new TextField({ name: "title", required: true }));
  addTableField(new TextField({ name: "columns_json", required: true }));
  addTableField(new NumberField({ name: "sort_order" }));
  addTableField(new TextField({ name: "updated_by_email" }));
  addTableField(new TextField({ name: "updated_by_name" }));

  app.save(tables);

  const savedTables = app.findCollectionByNameOrId("wiki_tables");
  if (wikiPages && !savedTables.fields.find((f) => f.name === "page")) {
    savedTables.fields.add(
      new RelationField({
        name: "page",
        collectionId: wikiPages.id,
        maxSelect: 1,
        required: false,
      }),
    );
    app.save(savedTables);
  }

  let rows = null;
  try {
    rows = app.findCollectionByNameOrId("wiki_table_rows");
  } catch (_) {}

  if (!rows) {
    rows = new Collection({
      name: "wiki_table_rows",
      type: "base",
      listRule: authRule,
      viewRule: authRule,
      createRule: writeRule,
      updateRule: writeRule,
      deleteRule: writeRule,
    });
  }

  const addRowField = (field) => {
    if (!rows.fields.find((f) => f.name === field.name)) {
      rows.fields.add(field);
    }
  };

  addRowField(new TextField({ name: "values_json", required: false }));
  addRowField(new NumberField({ name: "sort_order" }));

  app.save(rows);

  const savedRows = app.findCollectionByNameOrId("wiki_table_rows");
  const tablesCol = app.findCollectionByNameOrId("wiki_tables");
  if (
    tablesCol &&
    !savedRows.fields.find((f) => f.name === "wiki_table") &&
    !savedRows.fields.find((f) => f.name === "table")
  ) {
    savedRows.fields.add(
      new RelationField({
        name: "wiki_table",
        collectionId: tablesCol.id,
        maxSelect: 1,
        required: true,
      }),
    );
    app.save(savedRows);
  }
}, (app) => {
  try {
    const rows = app.findCollectionByNameOrId("wiki_table_rows");
    if (rows) app.delete(rows);
  } catch (_) {}
  try {
    const tables = app.findCollectionByNameOrId("wiki_tables");
    if (tables) app.delete(tables);
  } catch (_) {}
});
