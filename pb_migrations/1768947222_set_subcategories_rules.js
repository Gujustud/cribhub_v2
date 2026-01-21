/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  // Set rules for subcategories collection
  const subcategoriesCollection = app.findCollectionByNameOrId("subcategories");
  if (subcategoriesCollection) {
    subcategoriesCollection.listRule = 'id != ""';
    subcategoriesCollection.viewRule = 'id != ""';
    subcategoriesCollection.createRule = 'id != ""';
    subcategoriesCollection.updateRule = 'id != ""';
    subcategoriesCollection.deleteRule = 'id != ""';
    app.save(subcategoriesCollection);
  }

  // Set rules for attribute_lists collection
  const attributeListsCollection = app.findCollectionByNameOrId("attribute_lists");
  if (attributeListsCollection) {
    attributeListsCollection.listRule = 'id != ""';
    attributeListsCollection.viewRule = 'id != ""';
    attributeListsCollection.createRule = 'id != ""';
    attributeListsCollection.updateRule = 'id != ""';
    attributeListsCollection.deleteRule = 'id != ""';
    app.save(attributeListsCollection);
  }

  // Set rules for attribute_values collection
  const attributeValuesCollection = app.findCollectionByNameOrId("attribute_values");
  if (attributeValuesCollection) {
    attributeValuesCollection.listRule = 'id != ""';
    attributeValuesCollection.viewRule = 'id != ""';
    attributeValuesCollection.createRule = 'id != ""';
    attributeValuesCollection.updateRule = 'id != ""';
    attributeValuesCollection.deleteRule = 'id != ""';
    app.save(attributeValuesCollection);
  }
}, (app) => {
  // Revert: Remove rules (set to null)
  const subcategoriesCollection = app.findCollectionByNameOrId("subcategories");
  if (subcategoriesCollection) {
    subcategoriesCollection.listRule = null;
    subcategoriesCollection.viewRule = null;
    subcategoriesCollection.createRule = null;
    subcategoriesCollection.updateRule = null;
    subcategoriesCollection.deleteRule = null;
    app.save(subcategoriesCollection);
  }

  const attributeListsCollection = app.findCollectionByNameOrId("attribute_lists");
  if (attributeListsCollection) {
    attributeListsCollection.listRule = null;
    attributeListsCollection.viewRule = null;
    attributeListsCollection.createRule = null;
    attributeListsCollection.updateRule = null;
    attributeListsCollection.deleteRule = null;
    app.save(attributeListsCollection);
  }

  const attributeValuesCollection = app.findCollectionByNameOrId("attribute_values");
  if (attributeValuesCollection) {
    attributeValuesCollection.listRule = null;
    attributeValuesCollection.viewRule = null;
    attributeValuesCollection.createRule = null;
    attributeValuesCollection.updateRule = null;
    attributeValuesCollection.deleteRule = null;
    app.save(attributeValuesCollection);
  }
});
