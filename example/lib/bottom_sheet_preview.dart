import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:year_month_picker/year_month_picker.dart';

class BottomSheetPreview extends StatelessWidget {
  const BottomSheetPreview({
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
            final dateTime = await showYearMonthPickerBottomSheet(
              context: context,
              lastYear: 3000,
              firstYear: 2000,
              initialYearMonth: initYearMonth,
            );
            if (dateTime != null) {
              onYearMonthSelected?.call(dateTime);
            }
          },
          child: const Text('Show default bottom sheet'),
        ),
        ElevatedButton(
          onPressed: () async {
            final dateTime = await showYearMonthPickerBottomSheet(
              context: context,
              lastYear: 3000,
              firstYear: 2000,
              initialYearMonth: initYearMonth,
              backgroundColor: Colors.white,
              locale: const Locale("vi"),
              buildMonthItem: (context, month) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.redAccent, width: 0.5),
                    ),
                  ),
                  child: Text(
                    DateFormat.MMMM().format(DateTime(2025, month)),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                );
              },
              buildYearItem: (context, year) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.redAccent, width: 0.5),
                    ),
                  ),
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
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
          child: const Text('Show custom bottom sheet'),
        ),
      ],
    );
  }
}
