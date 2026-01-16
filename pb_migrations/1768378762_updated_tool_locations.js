/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_tool_locations")

  // add field
  collection.fields.addAt(3, new Field({
    "cascadeDelete": true,
    "collectionId": "pbc_tools",
    "hidden": false,
    "id": "relation552812241",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "tool",
    "presentable": false,
    "required": true,
    "system": false,
    "type": "relation"
  }))

  // add field
  collection.fields.addAt(4, new Field({
    "cascadeDelete": true,
    "collectionId": "pbc_locations",
    "hidden": false,
    "id": "relation1587448267",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "location",
    "presentable": false,
    "required": true,
    "system": false,
    "type": "relation"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_tool_locations")

  // remove field
  collection.fields.removeById("relation552812241")

  // remove field
  collection.fields.removeById("relation1587448267")

  return app.save(collection)
})
