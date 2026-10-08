/// <reference path="../pb_data/types.d.ts" />
// Personal dashboard quick notes pad on users (each user updates own record).

migrate((app) => {
  const users = app.findCollectionByNameOrId("users");
  if (!users) return;
  if (!users.fields.find((f) => f.name === "quick_notes")) {
    users.fields.add(
      new TextField({
        name: "quick_notes",
        required: false,
        max: 20000,
      }),
    );
    app.save(users);
  }
}, (app) => {
  const users = app.findCollectionByNameOrId("users");
  if (!users) return;
  const field = users.fields.find((f) => f.name === "quick_notes");
  if (field) {
    users.fields.removeById(field.id);
    app.save(users);
  }
});
