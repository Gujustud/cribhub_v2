/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_tool_locations")

  // update collection data
  unmarshal({
    "indexes": [
      "CREATE INDEX idx_qr_code ON tool_locations (qr_code)",
      "CREATE UNIQUE INDEX idx_tool_location ON tool_locations (tool, location)"
    ]
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_tool_locations")

  // update collection data
  unmarshal({
    "indexes": [
      "CREATE INDEX idx_qr_code ON tool_locations (qr_code)"
    ]
  }, collection)

  return app.save(collection)
})
