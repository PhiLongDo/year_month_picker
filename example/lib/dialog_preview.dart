import 'package:flutter/material.dart';

class DialogPreview extends StatelessWidget {
  const DialogPreview({
    this.onYearMonthSelected,
    this.initYearMonth,
    super.key,
  });

  final DateTime? initYearMonth;
  final void Function(DateTime dateTime)? onYearMonthSelected;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
