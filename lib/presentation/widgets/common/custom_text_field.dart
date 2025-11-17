import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final FocusNode? focusNode;
  // Aliases for backward compatibility
  final String? label;
  final String? hint;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.focusNode,
    // Aliases for backward compatibility
    this.label,
    this.hint,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    // Use alias if provided, otherwise use original parameter
    final effectiveLabelText = widget.label ?? widget.labelText;
    final effectiveHintText = widget.hint ?? widget.hintText;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        labelText: effectiveLabelText,
        hintText: effectiveHintText,
        helperText: widget.helperText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const PasswordTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      prefixIcon: Icons.lock_outline,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;

  const SearchTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText ?? 'Caută...',
      prefixIcon: Icons.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller?.clear();
                onClear?.call();
              },
            )
          : null,
    );
  }
}
