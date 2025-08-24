import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'validations.dart';

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
  required int lastYear,
  required int firstYear,
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
  validateYearMonthPickerParams(
    lastYear: lastYear,
    firstYear: firstYear,
    initialYearMonth: initialYearMonth,
  );

  Widget dialog = _YearMonthPickerDialog(
    lastYear: lastYear,
    firstYear: firstYear,
    initialYearMonth: initialYearMonth,
    buildMonthItem: buildMonthItem,
    buildCancelButton: buildCancelButton,
    buildOkButton: buildOkButton,
    buildYearItem: buildYearItem,
    buildHelperText: buildHelperText,
    onMonthChanged: onMonthChanged,
    onYearChanged: onYearChanged,
    backgroundColor: backgroundColor,
    locale: locale,
  );

  if (textDirection != null) {
    dialog = Directionality(textDirection: textDirection, child: dialog);
  }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showDialog<DateTime?>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}

class _YearMonthPickerDialog extends StatefulWidget {
  _YearMonthPickerDialog({
    required this.lastYear,
    required this.firstYear,
    this.buildYearItem,
    this.buildMonthItem,
    this.buildOkButton,
    this.buildCancelButton,
    this.buildHelperText,
    this.onYearChanged,
    this.onMonthChanged,
    this.backgroundColor,
    this.locale,
    DateTime? initialYearMonth,
  }) {
    validateYearMonthPickerParams(
      lastYear: lastYear,
      firstYear: firstYear,
      initialYearMonth: initialYearMonth,
    );
    this.initialYearMonth = initialYearMonth ?? DateTime.now();
  }

  final Color? backgroundColor;
  final Locale? locale;

  final int lastYear;
  final int firstYear;
  late final DateTime initialYearMonth;

  final Widget Function(BuildContext context, int year)? buildYearItem;
  final Widget Function(BuildContext context, int month)? buildMonthItem;
  final Widget Function(BuildContext context)? buildOkButton;
  final Widget Function(BuildContext context)? buildCancelButton;
  final Widget Function(BuildContext context)? buildHelperText;

  final void Function(int year)? onYearChanged;
  final void Function(int month)? onMonthChanged;
  @override
  State<_YearMonthPickerDialog> createState() => _YearMonthPickerDialogState();
}

class _YearMonthPickerDialogState extends State<_YearMonthPickerDialog> {
  Widget Function(BuildContext, int year) get _buildYearItem =>
      widget.buildYearItem ?? _defaultBuildYearItem;

  Widget Function(BuildContext, int month) get _buildMonthItem =>
      widget.buildMonthItem ?? _defaultBuildMonthItem;

  DateTime get _initYearMonth => widget.initialYearMonth;

  late int _year;
  late int _month;

  @override
  void initState() {
    _year = _initYearMonth.year;
    _month = _initYearMonth.month;
    widget.onYearChanged?.call(_year);
    widget.onMonthChanged?.call(_month);
    super.initState();
  }

  Widget _defaultBuildYearItem(BuildContext context, int number) => Text(
        '$number',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 18,
        ),
      );

  Widget _defaultBuildMonthItem(BuildContext context, int number) {
    return Text(
      DateFormat.MMMM(widget.locale?.languageCode)
          .format(DateTime(2025, number)),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.buildHelperText?.call(context) ?? const SizedBox.shrink(),
          Text(
            DateFormat.yMMMM(widget.locale?.languageCode)
                .format(DateTime(_year, _month)),
            style: const TextStyle(fontSize: 24),
          )
        ],
      ),
      backgroundColor: widget.backgroundColor,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: widget.buildCancelButton?.call(context) ??
              Text(localizations.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(DateTime(_year, _month));
          },
          child: widget.buildOkButton?.call(context) ??
              Text(localizations.okButtonLabel),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          _buildYearSelector(),
          _buildMonthSelector(),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _year > widget.firstYear
              ? () {
                  setState(() {
                    _year--;
                    widget.onYearChanged?.call(_year);
                  });
                }
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        DropdownButton<int>(
          value: _year,
          icon: const SizedBox.shrink(),
          items: List<DropdownMenuItem<int>>.generate(
            widget.lastYear - widget.firstYear + 1,
            (index) {
              final year = widget.firstYear + index;
              return DropdownMenuItem<int>(
                value: year,
                child: _buildYearItem(context, year),
              );
            },
          ),
          onChanged: (int? newYear) {
            if (newYear != null) {
              setState(() {
                _year = newYear;
                widget.onYearChanged?.call(_year);
              });
            }
          },
        ),
        IconButton(
          onPressed: _year < widget.lastYear
              ? () {
                  setState(() {
                    _year++;
                    widget.onYearChanged?.call(_year);
                  });
                }
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [for (var i = 0; i < 4; i++) _buildMonthRow(i)],
    );
  }

  Widget _buildMonthRow(int row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(3, (index) {
        final month = row * 3 + index + 1;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _month = month;
                widget.onMonthChanged?.call(_month);
              });
            },
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, minHeight: 60),
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 4.0,
              ),
              decoration: BoxDecoration(
                color: _month == month
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2)
                    : null,
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: _buildMonthItem(context, month),
            ),
          ),
        );
      }),
    );
  }
}
