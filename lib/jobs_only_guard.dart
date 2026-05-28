import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'jobs_screen.dart';

/// Blocks quote screens for `jobs_only` users (UI parity with DharmaCore).
void guardQuotesAccess(BuildContext context) {
  if (!AuthService.instance.isJobsOnly) return;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your account cannot access quotes.')),
    );
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const JobsScreen()),
      );
    }
  });
}
