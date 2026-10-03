import 'package:flutter/material.dart';

/// Email + password fields for non-web platforms (Flutter [TextFormField]s).
class NativeLoginFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback? onSubmit;
  final bool enabled;

  const NativeLoginFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.onSubmit,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: emailController,
            enabled: enabled,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [
              AutofillHints.username,
              AutofillHints.email,
            ],
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              final t = v?.trim() ?? '';
              if (t.isEmpty) return 'Email is required';
              if (!t.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            enabled: enabled,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => enabled ? onSubmit?.call() : null,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              if ((v ?? '').isEmpty) return 'Password is required';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
