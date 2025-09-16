import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'components/dropdown.dart';
import 'components/year_month_text.dart';
import 'validations.dart';

/// Displays a dialog allowing the user to pick a year and month.
///
/// This function shows a modal dialog with UI for selecting a year and a month.
/// It supports customization of year/month items, action buttons, helper text,
/// and the year-month display. Localization, text direction, and callbacks for
/// selection changes are also supported. The result is returned asynchronously
/// when the user confirms or cancels the dialog.
///
/// Parameters:
/// - `context` (required): The build context to display the dialog.
/// - `lastYear` (required): The maximum selectable year.
/// - `firstYear` (required): The minimum selectable year.
/// - `barrierDismissible` (default `true`): Whether tapping outside dismisses the dialog.
/// - `barrierColor` (optional): The color of the modal barrier behind the dialog.
/// - `barrierLabel` (optional): Accessibility label for the barrier.
/// - `useRootNavigator` (default `true`): Whether to use the root navigator.
/// - `routeSettings` (optional): Route settings for the dialog.
/// - `locale` (optional): Custom locale for the dialog.
/// - `textDirection` (optional): Text direction (LTR/RTL).
/// - `anchorPoint` (optional): The anchor point for the dialog position.
/// - `initialYearMonth` (optional): The initial year and month to display (defaults to now).
/// - `backgroundColor` (optional): Background color of the dialog.
/// - `yearItemBuilder` (optional): Custom builder for year items.
/// - `monthItemBuilder` (optional): Custom builder for month items.
/// - `okButtonBuilder` (optional): Custom builder for the OK button.
/// - `cancelButtonBuilder` (optional): Custom builder for the Cancel button.
/// - `helperTextBuilder` (optional): Custom builder for helper text above the picker.
/// - `yearMonthTextBuilder` (optional): Custom builder for the year-month display.
/// - `onYearChanged` (optional): Callback when the year changes.
/// - `onMonthChanged` (optional): Callback when the month changes.
///
/// Returns:
/// - `Future<DateTime?>`: Resolves to the selected year and month as a `DateTime` if confirmed,
///   or `null` if the user cancels or dismisses the dialog.
Future<DateTime?> showYearMonthPickerDialog({
  required BuildContext context,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Locale? locale,
  TextDirection? textDirection,
  Offset? anchorPoint,
  required int lastYear,
  required int firstYear,
  DateTime? initialYearMonth,
  Color? backgroundColor,
  Widget Function(BuildContext context, int year)? yearItemBuilder,
  Widget Function(BuildContext context, int month)? monthItemBuilder,
  Widget Function(BuildContext context)? okButtonBuilder,
  Widget Function(BuildContext context)? cancelButtonBuilder,
  Widget Function(BuildContext context)? helperTextBuilder,
  Widget Function(BuildContext context, int year, int month)?
      yearMonthTextBuilder,
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
    monthItemBuilder: monthItemBuilder,
    cancelButtonBuilder: cancelButtonBuilder,
    okButtonBuilder: okButtonBuilder,
    yearItemBuilder: yearItemBuilder,
    helperTextBuilder: helperTextBuilder,
    yearMonthTextBuilder: yearMonthTextBuilder,
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
    this.yearItemBuilder,
    this.monthItemBuilder,
    this.okButtonBuilder,
    this.cancelButtonBuilder,
    this.helperTextBuilder,
    this.yearMonthTextBuilder,
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

  final Widget Function(BuildContext context, int year)? yearItemBuilder;
  final Widget Function(BuildContext context, int month)? monthItemBuilder;
  final Widget Function(BuildContext context)? okButtonBuilder;
  final Widget Function(BuildContext context)? cancelButtonBuilder;
  final Widget Function(BuildContext context)? helperTextBuilder;
  final Widget Function(BuildContext context, int year, int month)?
      yearMonthTextBuilder;

  final void Function(int year)? onYearChanged;
  final void Function(int month)? onMonthChanged;

  @override
  State<_YearMonthPickerDialog> createState() => _YearMonthPickerDialogState();
}

class _YearMonthPickerDialogState extends State<_YearMonthPickerDialog> {
  Widget Function(BuildContext, int year) get _buildYearItem =>
      widget.yearItemBuilder ?? _defaultBuildYearItem;

  Widget Function(BuildContext, int month) get _buildMonthItem =>
      widget.monthItemBuilder ?? _defaultBuildMonthItem;

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
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget _defaultBuildMonthItem(BuildContext context, int number) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final pattern = deviceWidth > 412 ? 'MMMM' : 'MMM';
    return Text(
      DateFormat(pattern, widget.locale?.languageCode)
          .format(DateTime(2025, number)),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.helperTextBuilder?.call(context) ??
                  const SizedBox.shrink(),
              _buildYearMonthText(),
              const Divider(),
              _buildYearSelector(),
              _buildMonthSelector(),
              const SizedBox(height: 6.0),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearMonthText() {
    return widget.yearMonthTextBuilder?.call(context, _year, _month) ??
        YearMonthText(locale: widget.locale, year: _year, month: _month);
  }

  Widget _buildYearSelector() {
    final listYears = List<int>.generate(
      widget.lastYear - widget.firstYear + 1,
      (index) => widget.firstYear + index,
    );
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
        Dropdown(
          value: _year,
          items: listYears,
          itemBuilder: (BuildContext context, int index) {
            return _buildYearItem(context, listYears[index]);
          },
          selectedItemBuilder: (BuildContext context) {
            return DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.2)),
                ),
                child: _buildYearItem(context, _year));
          },
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
    final borderRadius = BorderRadius.circular(8.0);
    final deviceWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(3, (index) {
        final month = row * 3 + index + 1;
        return InkWell(
          onTap: () {
            setState(() {
              _month = month;
              widget.onMonthChanged?.call(_month);
            });
          },
          borderRadius: borderRadius,
          child: Container(
            constraints: BoxConstraints(
              minWidth: deviceWidth > 412 ? 100 : 80,
              minHeight: 60,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 4.0,
            ),
            decoration: BoxDecoration(
              color: _month == month
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                  : null,
              borderRadius: borderRadius,
            ),
            alignment: Alignment.center,
            child: _buildMonthItem(context, month),
          ),
        );
      }),
    );
  }

  Widget _buildActions(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      spacing: 8.0,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          style: ButtonStyle(
            padding: widget.okButtonBuilder != null
                ? WidgetStateProperty.all(const EdgeInsets.all(0))
                : null,
          ),
          child: widget.cancelButtonBuilder?.call(context) ??
              Text(localizations.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(DateTime(_year, _month));
          },
          style: ButtonStyle(
            padding: widget.okButtonBuilder != null
                ? WidgetStateProperty.all(const EdgeInsets.all(0))
                : null,
          ),
          child: widget.okButtonBuilder?.call(context) ??
              Text(localizations.okButtonLabel),
        ),
      ],
    );
  }
}
