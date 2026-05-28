import 'package:flutter/material.dart';

/// Return to the app home route (dashboard).
void goToDashboard(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}
