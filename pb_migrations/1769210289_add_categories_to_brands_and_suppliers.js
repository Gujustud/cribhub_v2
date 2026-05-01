/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const categories = app.findCollectionByNameOrId("categories")
  const brands = app.findCollectionByNameOrId("brands")
  const suppliers = app.findCollectionByNameOrId("suppliers")

  function hasField(collection, name) {
    for (const f of collection.fields) {
      if (f.name === name) return true
    }
    return false
  }

  if (!hasField(brands, "categories")) {
    brands.fields.add(
      new Field({
        cascadeDelete: false,
        collectionId: categories.id,
        hidden: false,
        id: "relation921028901",
        maxSelect: 200,
        minSelect: 0,
        name: "categories",
        presentable: false,
        required: false,
        system: false,
        type: "relation",
      })
    )
    app.save(brands)
  }

  if (!hasField(suppliers, "categories")) {
    suppliers.fields.add(
      new Field({
        cascadeDelete: false,
        collectionId: categories.id,
        hidden: false,
        id: "relation921028902",
        maxSelect: 200,
        minSelect: 0,
        name: "categories",
        presentable: false,
        required: false,
        system: false,
        type: "relation",
      })
    )
    app.save(suppliers)
  }
}, (app) => {
  const brands = app.findCollectionByNameOrId("brands")
  const suppliers = app.findCollectionByNameOrId("suppliers")

  if (brands) {
    try {
      brands.fields.removeById("relation921028901")
      app.save(brands)
    } catch (_) {}
  }
  if (suppliers) {
    try {
      suppliers.fields.removeById("relation921028902")
      app.save(suppliers)
    } catch (_) {}
  }
})
