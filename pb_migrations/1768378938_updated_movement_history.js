/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_movement_history")

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
    "cascadeDelete": false,
    "collectionId": "pbc_locations",
    "hidden": false,
    "id": "relation410085713",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "from_location",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  // add field
  collection.fields.addAt(5, new Field({
    "cascadeDelete": false,
    "collectionId": "pbc_locations",
    "hidden": false,
    "id": "relation2479298405",
    "maxSelect": 1,
    "minSelect": 0,
    "name": "to_location",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "relation"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_movement_history")

  // remove field
  collection.fields.removeById("relation552812241")

  // remove field
  collection.fields.removeById("relation410085713")

  // remove field
  collection.fields.removeById("relation2479298405")

  return app.save(collection)
})
