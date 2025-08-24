import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:year_month_picker/year_month_picker.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        ElevatedButton(
          onPressed: () async {
            final dateTime = await showYearMonthPickerDialog(
              context: context,
              lastYear: 3000,
              firstYear: 2000,
              initialYearMonth: initYearMonth,
            );
            if (dateTime != null) {
              onYearMonthSelected?.call(dateTime);
            }
          },
          child: const Text('Show default dialog'),
        ),
        ElevatedButton(
          onPressed: () async {
            final dateTime = await showYearMonthPickerDialog(
              context: context,
              lastYear: 3000,
              firstYear: 2000,
              initialYearMonth: initYearMonth,
              backgroundColor: Colors.white,
              locale: const Locale("vi"),
              buildMonthItem: (context, month) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat.MMMM("vi").format(DateTime(2025, month)),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                );
              },
              buildYearItem: (context, year) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    '$year',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                );
              },
              buildOkButton: (context) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    MaterialLocalizations.of(context).okButtonLabel,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                );
              },
              buildCancelButton: (context) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                );
              },
            );
            if (dateTime != null) {
              onYearMonthSelected?.call(dateTime);
            }
          },
          child: const Text('Show custom dialog'),
        ),
      ],
    );
  }
}
