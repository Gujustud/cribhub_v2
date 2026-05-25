import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'drawer_behavior.dart';
import 'pocketbase_service.dart';

/// Add or edit a `customers` record.
class CustomerDetailScreen extends StatefulWidget {
  /// null = new customer, non-null = edit
  final dynamic customer;

  const CustomerDetailScreen({super.key, this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> with AutoOpenDrawerMixin {
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSaving = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool get _isNew => widget.customer == null;

  @override
  void initState() {
    super.initState();
    if (!_isNew) {
      final d = widget.customer.data as Map<String, dynamic>? ?? {};
      _nameController.text = '${d['name'] ?? ''}';
      _companyController.text = '${d['company'] ?? ''}';
      _addressController.text = '${d['address'] ?? ''}';
      _emailController.text = '${d['email'] ?? ''}';
      _phoneController.text = '${d['phone'] ?? ''}';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      final pb = PocketBaseService();
      final name = _nameController.text.trim();
      final company = _companyController.text.trim();
      final address = _addressController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();

      if (_isNew) {
        await pb.createCustomer(
          name: name,
          company: company.isEmpty ? null : company,
          address: address.isEmpty ? null : address,
          email: email.isEmpty ? null : email,
          phone: phone.isEmpty ? null : phone,
        );
      } else {
        await pb.updateCustomer(
          id: widget.customer.id,
          name: name,
          company: company.isEmpty ? null : company,
          address: address.isEmpty ? null : address,
          email: email.isEmpty ? null : email,
          phone: phone.isEmpty ? null : phone,
        );
      }
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isNew ? 'Customer added' : 'Customer updated'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    maybeAutoOpenDrawer();
    final title = _isNew
        ? 'Add customer'
        : (_nameController.text.trim().isEmpty ? 'Customer' : _nameController.text.trim());

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field(controller: _nameController, label: 'Name *'),
                _field(controller: _companyController, label: 'Company'),
                _field(controller: _addressController, label: 'Address', maxLines: 2),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(
                        controller: _phoneController,
                        label: 'Phone',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(_isNew ? 'ADD CUSTOMER' : 'SAVE CHANGES',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
