/// <reference path="../pb_data/types.d.ts" />
// DharmaCore parity: users.role (full | jobs_only) + authenticated API rules.
// quotes / quote_line_items deny jobs_only; other shop collections require login.

migrate((app) => {
  const usersCollection = app.findCollectionByNameOrId("users");
  if (usersCollection) {
    const hasRole = usersCollection.fields.find((f) => f.name === "role");
    if (!hasRole) {
      usersCollection.fields.add(
        new SelectField({
          name: "role",
          required: false,
          values: ["full", "jobs_only"],
        }),
      );
      app.save(usersCollection);
    }
  }

  const authRule = '@request.auth.id != ""';
  const quoteRule = '@request.auth.id != "" && @request.auth.role != "jobs_only"';

  const quoteCollections = ["quotes", "quote_line_items"];
  for (const name of quoteCollections) {
    const col = app.findCollectionByNameOrId(name);
    if (!col) continue;
    col.listRule = quoteRule;
    col.viewRule = quoteRule;
    col.createRule = quoteRule;
    col.updateRule = quoteRule;
    col.deleteRule = quoteRule;
    app.save(col);
  }

  const authCollections = [
    "jobs",
    "customers",
    "settings",
    "inventory",
    "locations",
    "tool_locations",
    "movement_history",
    "brands",
    "suppliers",
    "purchases",
    "purchase_items",
    "buy_list_manual",
    "categories",
    "subcategories",
    "sub_subcategories",
    "alloys",
  ];

  for (const name of authCollections) {
    const col = app.findCollectionByNameOrId(name);
    if (!col) continue;
    col.listRule = authRule;
    col.viewRule = authRule;
    col.createRule = authRule;
    col.updateRule = authRule;
    col.deleteRule = authRule;
    app.save(col);
  }
}, (app) => {
  const openList = 'id != ""';
  const openCrud = '@request.auth.id != ""';

  const quoteCollections = ["quotes", "quote_line_items"];
  for (const name of quoteCollections) {
    const col = app.findCollectionByNameOrId(name);
    if (!col) continue;
    col.listRule = openList;
    col.viewRule = openList;
    col.createRule = openCrud;
    col.updateRule = openCrud;
    col.deleteRule = openCrud;
    app.save(col);
  }

  const authCollections = [
    "jobs",
    "customers",
    "settings",
    "inventory",
    "locations",
    "tool_locations",
    "movement_history",
    "brands",
    "suppliers",
    "purchases",
    "purchase_items",
    "buy_list_manual",
    "categories",
    "subcategories",
    "sub_subcategories",
    "alloys",
  ];

  for (const name of authCollections) {
    const col = app.findCollectionByNameOrId(name);
    if (!col) continue;
    col.listRule = null;
    col.viewRule = null;
    col.createRule = null;
    col.updateRule = null;
    col.deleteRule = null;
    app.save(col);
  }

  const usersCollection = app.findCollectionByNameOrId("users");
  if (usersCollection) {
    const roleField = usersCollection.fields.find((f) => f.name === "role");
    if (roleField) {
      usersCollection.fields.removeById(roleField.id);
      app.save(usersCollection);
    }
  }
});
