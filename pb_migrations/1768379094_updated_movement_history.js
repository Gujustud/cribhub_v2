/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_movement_history")

  // update collection data
  unmarshal({
    "indexes": [
      "CREATE INDEX idx_movement_tool ON movement_history (tool)"
    ]
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_movement_history")

  // update collection data
  unmarshal({
    "indexes": []
  }, collection)

  return app.save(collection)
})
