/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  // Add categories relation field to brands collection
  const brandsCollection = db.collection('brands');
  const brandsSchema = brandsCollection.schema;
  
  // Check if field already exists
  if (!brandsSchema.fields.find(f => f.name === 'categories')) {
    brandsSchema.fields.push({
      name: 'categories',
      type: 'relation',
      required: false,
      presentable: false,
      unique: false,
      options: {
        collectionId: 'categories',
        cascadeDelete: false,
        minSelect: null,
        maxSelect: null,
        displayFields: ['name']
      }
    });
    brandsCollection.schema = brandsSchema;
  }

  // Add categories relation field to suppliers collection
  const suppliersCollection = db.collection('suppliers');
  const suppliersSchema = suppliersCollection.schema;
  
  // Check if field already exists
  if (!suppliersSchema.fields.find(f => f.name === 'categories')) {
    suppliersSchema.fields.push({
      name: 'categories',
      type: 'relation',
      required: false,
      presentable: false,
      unique: false,
      options: {
        collectionId: 'categories',
        cascadeDelete: false,
        minSelect: null,
        maxSelect: null,
        displayFields: ['name']
      }
    });
    suppliersCollection.schema = suppliersSchema;
  }

  return {
    brands: brandsCollection,
    suppliers: suppliersCollection
  };
}, (db) => {
  // Rollback: Remove categories field from brands and suppliers
  const brandsCollection = db.collection('brands');
  const brandsSchema = brandsCollection.schema;
  brandsSchema.fields = brandsSchema.fields.filter(f => f.name !== 'categories');
  brandsCollection.schema = brandsSchema;

  const suppliersCollection = db.collection('suppliers');
  const suppliersSchema = suppliersCollection.schema;
  suppliersSchema.fields = suppliersSchema.fields.filter(f => f.name !== 'categories');
  suppliersCollection.schema = suppliersSchema;

  return {
    brands: brandsCollection,
    suppliers: suppliersCollection
  };
});
