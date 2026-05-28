/// Display labels for PocketBase `customers` (company is primary; name is contact).
String customerDisplayLabel(Map<String, dynamic> data, {String fallback = 'Unnamed customer'}) {
  final company = '${data['company'] ?? ''}'.trim();
  final name = '${data['name'] ?? ''}'.trim();
  if (company.isNotEmpty) return company;
  if (name.isNotEmpty) return name;
  return fallback;
}

/// Contact person line for list subtitle when company and name differ.
String? customerContactLine(Map<String, dynamic> data) {
  final company = '${data['company'] ?? ''}'.trim();
  final name = '${data['name'] ?? ''}'.trim();
  if (company.isNotEmpty && name.isNotEmpty) return name;
  return null;
}
