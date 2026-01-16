/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_brands")

  // update collection data
  unmarshal({
    "createRule": "id != \"\""
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_brands")

  // update collection data
  unmarshal({
    "createRule": null
  }, collection)

  return app.save(collection)
})
