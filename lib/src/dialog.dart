import 'package:flutter/material.dart';

Future<DateTime?> showYearMonthPickerDialog({
  // Dialog params
  required BuildContext context,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Locale? locale,
  TextDirection? textDirection,
  Offset? anchorPoint,

  // Year month picker params
  required int maxYear,
  required int minYear,
  DateTime? initialYearMonth,
  Color? backgroundColor,
  Widget Function(BuildContext context, int year)? buildYearItem,
  Widget Function(BuildContext context, int month)? buildMonthItem,
  Widget Function(BuildContext context)? buildOkButton,
  Widget Function(BuildContext context)? buildCancelButton,
  Widget Function(BuildContext context)? buildHelperText,
  void Function(int year)? onYearChanged,
  void Function(int month)? onMonthChanged,
}) {
  return showDialog<DateTime?>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    builder: (BuildContext context) {
      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);

      return const Padding(
        padding: EdgeInsets.all(8.0),
      );
    },
  );
}

class _YearMonthPickerDialog extends StatefulWidget {
  const _YearMonthPickerDialog();

  @override
  State<_YearMonthPickerDialog> createState() => _YearMonthPickerDialogState();
}

class _YearMonthPickerDialogState extends State<_YearMonthPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
