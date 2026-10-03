// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

var _viewCounter = 0;
var _styleInjected = false;

const _sharedCss = '''
.ncf-field { position: relative; margin: 0; }
.ncf-field input {
  width: 100%;
  box-sizing: border-box;
  height: 56px;
  padding: 20px 12px 4px 12px;
  font-size: 16px;
  font-family: Roboto, "Segoe UI", Arial, sans-serif;
  border: 1px solid var(--ncf-border, #767676);
  border-radius: var(--ncf-radius, 4px);
  background: var(--ncf-fill, transparent);
  color: var(--ncf-text, #000);
  outline: none;
}
.ncf-field input:focus {
  border: 2px solid var(--ncf-focus, #1976d2);
  padding: 19px 11px 3px 11px;
}
.ncf-field input:disabled {
  opacity: 0.6;
}
.ncf-field label {
  position: absolute;
  left: 13px;
  top: 18px;
  font-size: 16px;
  color: var(--ncf-label, #666);
  transition: all 0.15s ease;
  pointer-events: none;
  background: var(--ncf-fill, transparent);
  padding: 0 4px;
}
.ncf-field input:focus + label,
.ncf-field input:not(:placeholder-shown) + label {
  top: -9px;
  left: 9px;
  font-size: 12px;
  color: var(--ncf-focus, #1976d2);
}
''';

void _ensureStyleInjected() {
  if (_styleInjected) return;
  _styleInjected = true;
  html.document.head!.append(html.StyleElement()..text = _sharedCss);
}

String _cssColor(Color c) {
  final r = (c.r * 255).round();
  final g = (c.g * 255).round();
  final b = (c.b * 255).round();
  return 'rgba($r,$g,$b,${c.a})';
}

/// Web-only: real HTML email/password inputs so Bitwarden can autofill.
///
/// Flutter canvas [TextField]s only give the focused field real DOM size;
/// Bitwarden refuses to fill when the other field is 0×0.
class NativeLoginFields extends StatefulWidget {
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
  State<NativeLoginFields> createState() => _NativeLoginFieldsState();
}

class _NativeLoginFieldsState extends State<NativeLoginFields> {
  late final String _viewType = 'native-login-fields-${_viewCounter++}';
  html.InputElement? _emailInput;
  html.InputElement? _passwordInput;
  html.DivElement? _emailField;
  html.DivElement? _passwordField;

  @override
  void initState() {
    super.initState();
    _ensureStyleInjected();
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int id) {
      final form = html.FormElement()
        ..setAttribute('autocomplete', 'on')
        ..method = 'post'
        ..action = '#'
        ..style.width = '100%'
        ..style.margin = '0'
        ..style.display = 'flex'
        ..style.flexDirection = 'column'
        ..style.gap = '16px';
      form.onSubmit.listen((e) {
        e.preventDefault();
        if (widget.enabled) widget.onSubmit?.call();
      });

      final emailField = _buildField(
        type: 'email',
        name: 'username',
        autocomplete: 'username',
        label: 'Email',
        initialValue: widget.emailController.text,
        onInput: (value) => widget.emailController.text = value,
      );
      final emailInput = emailField.querySelector('input') as html.InputElement;
      emailInput.autofocus = true;
      _emailInput = emailInput;
      _emailField = emailField;

      final passwordField = _buildField(
        type: 'password',
        name: 'password',
        autocomplete: 'current-password',
        label: 'Password',
        initialValue: widget.passwordController.text,
        onInput: (value) => widget.passwordController.text = value,
      );
      final passwordInput =
          passwordField.querySelector('input') as html.InputElement;
      passwordInput.onKeyDown.listen((e) {
        if (e.key != 'Enter') return;
        e.preventDefault();
        if (widget.enabled) widget.onSubmit?.call();
      });
      _passwordInput = passwordInput;
      _passwordField = passwordField;

      form.append(emailField);
      form.append(passwordField);
      _applyEnabled();
      _applyTheme();
      return form;
    });
  }

  html.DivElement _buildField({
    required String type,
    required String name,
    required String autocomplete,
    required String label,
    required String initialValue,
    required void Function(String value) onInput,
  }) {
    final input = html.InputElement(type: type)
      ..name = name
      ..id = 'cribhub-$name'
      ..setAttribute('autocomplete', autocomplete)
      ..placeholder = ' '
      ..value = initialValue;
    input.onInput.listen((_) => onInput(input.value ?? ''));

    final field = html.DivElement()..className = 'ncf-field';
    field.append(input);
    field.append(html.LabelElement()
      ..text = label
      ..htmlFor = 'cribhub-$name');
    return field;
  }

  void _applyEnabled() {
    final disabled = !widget.enabled;
    _emailInput?.disabled = disabled;
    _passwordInput?.disabled = disabled;
  }

  void _applyTheme() {
    if (!mounted) return;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final cardColor = theme.cardTheme.color ?? scheme.surface;

    for (final field in [_emailField, _passwordField]) {
      if (field == null) continue;
      field.style
        ..setProperty('--ncf-border', _cssColor(scheme.outline))
        ..setProperty('--ncf-focus', _cssColor(scheme.primary))
        ..setProperty('--ncf-fill', _cssColor(cardColor))
        ..setProperty('--ncf-text', _cssColor(scheme.onSurface))
        ..setProperty('--ncf-label', _cssColor(scheme.onSurfaceVariant))
        ..setProperty('--ncf-radius', '4px');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applyTheme();
  }

  @override
  void didUpdateWidget(covariant NativeLoginFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      _applyEnabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
