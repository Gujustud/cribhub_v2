/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_tools")

  // Remove the old select field
  collection.fields.removeById("select_tools_category")

  // Add new text field at position 2 (after id and tool_name)
  collection.fields.addAt(2, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_tools_category",
    "max": 100,
    "min": 0,
    "name": "category",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": true,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_tools")

  // Revert: Remove text field and add back select field
  collection.fields.removeById("text_tools_category")

  collection.fields.addAt(2, new Field({
    "hidden": false,
    "id": "select_tools_category",
    "maxSelect": 1,
    "name": "category",
    "presentable": false,
    "required": true,
    "system": false,
    "type": "select",
    "values": [
      "Cutting Tools",
      "Workholding",
      "Inspection",
      "Misc"
    ]
  }))

  return app.save(collection)
})
