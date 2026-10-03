import 'package:flutter/material.dart';

import 'models.dart';
import 'pocketbase_service.dart';

/// Shared create/edit dialog for [ShopMaterial]. Returns the saved record.
Future<ShopMaterial?> showShopMaterialEditor(
  BuildContext context, {
  ShopMaterial? existing,
}) {
  return showDialog<ShopMaterial>(
    context: context,
    builder: (ctx) => _ShopMaterialEditorDialog(existing: existing),
  );
}

class _ShopMaterialEditorDialog extends StatefulWidget {
  const _ShopMaterialEditorDialog({this.existing});

  final ShopMaterial? existing;

  @override
  State<_ShopMaterialEditorDialog> createState() =>
      _ShopMaterialEditorDialogState();
}

class _ShopMaterialEditorDialogState extends State<_ShopMaterialEditorDialog> {
  late final TextEditingController _gradeCtrl;
  late final TextEditingController _sizeCtrl;
  late final TextEditingController _notesCtrl;
  late String _form;
  late String _unit;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _gradeCtrl = TextEditingController(text: existing?.grade ?? '');
    _sizeCtrl = TextEditingController(text: existing?.sizeLabel ?? '');
    _notesCtrl = TextEditingController(text: existing?.notes ?? '');
    _form = existing?.form ?? 'bar';
    _unit = existing?.unit ?? 'ea';
  }

  @override
  void dispose() {
    _gradeCtrl.dispose();
    _sizeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final grade = _gradeCtrl.text.trim();
    final size = _sizeCtrl.text.trim();
    if (grade.isEmpty || size.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grade and size are required')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final pb = PocketBaseService();
      final existing = widget.existing;
      final rec = existing != null
          ? await pb.updateMaterial(
              existing.id,
              grade: grade,
              form: _form,
              sizeLabel: size,
              unit: _unit,
              notes: _notesCtrl.text,
            )
          : await pb.createMaterial(
              grade: grade,
              form: _form,
              sizeLabel: size,
              unit: _unit,
              notes: _notesCtrl.text,
            );
      if (!mounted) return;
      Navigator.pop(context, ShopMaterial.fromRecord(rec));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit material' : 'New material'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _gradeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Grade / alloy',
                  hintText: 'e.g. 4140, 6061-T6',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                enabled: !_saving,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: _form,
                decoration: const InputDecoration(
                  labelText: 'Form',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'bar', child: Text('Bar')),
                  DropdownMenuItem(value: 'plate', child: Text('Plate')),
                  DropdownMenuItem(value: 'sheet', child: Text('Sheet')),
                  DropdownMenuItem(value: 'tube', child: Text('Tube')),
                  DropdownMenuItem(value: 'hex', child: Text('Hex')),
                  DropdownMenuItem(value: 'flat', child: Text('Flat')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: _saving
                    ? null
                    : (v) {
                        if (v != null) setState(() => _form = v);
                      },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sizeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Size',
                  hintText: 'e.g. 1.5" OD x 12", 0.5 x 4 x 12',
                  border: OutlineInputBorder(),
                ),
                enabled: !_saving,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: _unit,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'ea', child: Text('Each')),
                  DropdownMenuItem(value: 'ft', child: Text('Feet')),
                  DropdownMenuItem(value: 'in', child: Text('Inches')),
                  DropdownMenuItem(value: 'lb', child: Text('Pounds')),
                  DropdownMenuItem(value: 'kg', child: Text('Kilograms')),
                ],
                onChanged: _saving
                    ? null
                    : (v) {
                        if (v != null) setState(() => _unit = v);
                      },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                enabled: !_saving,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_isEdit ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}
