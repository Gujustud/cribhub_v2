/// <reference path="../pb_data/types.d.ts" />
// Fix wiki_table_rows: relation field "table" breaks list filters (400).
// Rename to wiki_table; relax values_json required.

migrate((app) => {
  let rows = null;
  try {
    rows = app.findCollectionByNameOrId("wiki_table_rows");
  } catch (_) {
    return;
  }
  if (!rows) return;

  const tablesCol = app.findCollectionByNameOrId("wiki_tables");
  if (!tablesCol) return;

  const oldTable = rows.fields.find((f) => f.name === "table");
  const hasWikiTable = rows.fields.find((f) => f.name === "wiki_table");

  if (oldTable && !hasWikiTable) {
    rows.fields.removeById(oldTable.id);
    rows.fields.add(
      new RelationField({
        name: "wiki_table",
        collectionId: tablesCol.id,
        maxSelect: 1,
        required: true,
      }),
    );
  } else if (!hasWikiTable && !oldTable) {
    rows.fields.add(
      new RelationField({
        name: "wiki_table",
        collectionId: tablesCol.id,
        maxSelect: 1,
        required: true,
      }),
    );
  }

  const values = rows.fields.find((f) => f.name === "values_json");
  if (values && values.required) {
    values.required = false;
  }

  app.save(rows);
}, (app) => {
  // no-op: keep wiki_table name
});
