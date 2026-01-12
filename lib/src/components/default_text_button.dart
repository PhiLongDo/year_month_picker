import 'package:flutter/material.dart';

class DefaultTextButton extends StatelessWidget {
  const DefaultTextButton({
    super.key,
    required this.label,
    this.childBuilder,
    this.onPressed,
  });

  final String label;
  final Widget Function(BuildContext context)? childBuilder;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: childBuilder != null
            ? WidgetStateProperty.all(const EdgeInsets.all(0))
            : null,
      ),
      child: childBuilder?.call(context) ?? Text(label),
    );
  }
}
