/// Ensure wiki_pages.attachments accepts PDFs (and common images).
/// Older deploys may have created the field without application/pdf in mimeTypes.
migrate((app) => {
  const wiki = app.findCollectionByNameOrId("wiki_pages");
  const field = wiki.fields.getByName("attachments");
  if (!field) return;

  field.maxSelect = 12;
  field.maxSize = 52428800;
  field.mimeTypes = [
    "image/jpeg",
    "image/png",
    "image/gif",
    "image/webp",
    "application/pdf",
  ];
  app.save(wiki);
}, (app) => {});
