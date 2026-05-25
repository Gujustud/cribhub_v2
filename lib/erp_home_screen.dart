import 'package:flutter/material.dart';
import 'customers_screen.dart';
import 'jobs_screen.dart';
import 'quotes_screen.dart';
import 'suppliers_screen.dart';

/// Entry point for shop ERP features (quotes, jobs, customers).
/// Week 1: navigation shell; screens fill in per ERP plan.
class ErpHomeScreen extends StatelessWidget {
  const ErpHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop ERP'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'ERP overview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Inventory and purchases stay under the main menu. '
            'Customer quotes and jobs will live here as we build them out.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Customers'),
            subtitle: const Text('People and companies you quote.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const CustomersScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_quote_outlined),
            title: const Text('Quotes'),
            subtitle: const Text('View quotes and line items.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const QuotesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Jobs'),
            subtitle: const Text('Shop work — add, edit, and link to quotes.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const JobsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.store_outlined),
            title: const Text('Suppliers (tooling & vendors)'),
            subtitle: const Text('Existing CribHub suppliers — use for vendor-style contacts today.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const SuppliersScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _placeholderTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).disabledColor),
      title: Text(title),
      subtitle: Text(subtitle),
      enabled: false,
    );
  }
}
