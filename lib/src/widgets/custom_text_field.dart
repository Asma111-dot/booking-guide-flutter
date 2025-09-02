import 'package:flutter/material.dart';

import '../utils/assets.dart';
import '../utils/sizes.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.label,
        labelStyle: TextStyle(
          fontSize: TFont.m14,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: TFont.m14,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),

        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: S.w(16),
          vertical: S.h(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Corners.md15,
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
            width: S.r(1.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Corners.md15,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: S.r(1.5),
          ),
        ),

        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscure ? invisibleIcon: visibleIcon,
            color: colorScheme.primary,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        )
            : null,
      ),

      style: theme.textTheme.bodyMedium?.copyWith(
        fontFamily: 'Roboto',
        fontSize: TFont.m14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
    );
  }
}
