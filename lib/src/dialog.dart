import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:year_month_picker/src/utils.dart';

import 'components/default_text_button.dart';
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

/// A private [StatefulWidget] that represents the content of the year/month picker dialog.
///
/// This widget is responsible for displaying the UI for year and month selection,
/// handling user interactions, and managing the internal state of the selected date.
class _YearMonthPickerDialog extends StatefulWidget {
  /// Creates an instance of [_YearMonthPickerDialog].
  ///
  /// Parameters are typically passed from [showYearMonthPickerDialog].
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

  /// The background color of the dialog.
  final Color? backgroundColor;

  /// The locale used for formatting text within the dialog.
  final Locale? locale;

  /// The maximum selectable year.
  final int lastYear;

  /// The minimum selectable year.
  final int firstYear;

  /// The initially selected year and month.
  /// Defaults to the current date and time if not specified in the constructor.
  late final DateTime initialYearMonth;

  /// Optional custom builder for year items in the dropdown.
  final Widget Function(BuildContext context, int year)? yearItemBuilder;

  /// Optional custom builder for month items in the grid.
  final Widget Function(BuildContext context, int month)? monthItemBuilder;

  /// Optional custom builder for the OK button.
  final Widget Function(BuildContext context)? okButtonBuilder;

  /// Optional custom builder for the Cancel button.
  final Widget Function(BuildContext context)? cancelButtonBuilder;

  /// Optional custom builder for the helper text displayed above the picker.
  final Widget Function(BuildContext context)? helperTextBuilder;

  /// Optional custom builder for the year-month display text.
  final Widget Function(BuildContext context, int year, int month)?
      yearMonthTextBuilder;

  /// Callback invoked when the selected year changes.
  final void Function(int year)? onYearChanged;

  /// Callback invoked when the selected month changes.
  final void Function(int month)? onMonthChanged;

  @override
  State<_YearMonthPickerDialog> createState() => _YearMonthPickerDialogState();
}

/// The state for the [_YearMonthPickerDialog].
///
/// Manages the currently selected year and month, and builds the UI
/// for the dialog content. It handles user interactions for selecting
/// a year and month, and updates the display accordingly.
class _YearMonthPickerDialogState extends State<_YearMonthPickerDialog> {
  /// Returns the effective year item builder.
  ///
  /// Defaults to [_defaultBuildYearItem] if [widget.yearItemBuilder] is null.
  Widget Function(BuildContext, int year) get _buildYearItem =>
      widget.yearItemBuilder ?? _defaultBuildYearItem;

  /// Returns the effective month item builder.
  ///
  /// Defaults to [_defaultBuildMonthItem] if [widget.monthItemBuilder] is null.
  Widget Function(BuildContext, int month) get _buildMonthItem =>
      widget.monthItemBuilder ?? _defaultBuildMonthItem;

  /// Gets the initial year and month from the widget.
  DateTime get _initYearMonth => widget.initialYearMonth;

  late int _year;
  late int _month;

  @override
  void initState() {
    _year = _initYearMonth.year;
    _month = _initYearMonth.month;
    // Notify listeners about the initial state.
    widget.onYearChanged?.call(_year);
    widget.onMonthChanged?.call(_month);
    super.initState();
  }

  /// Builds the default widget for a year item, displaying the year number.
  Widget _defaultBuildYearItem(BuildContext context, int number) => Text(
        '$number',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      );

  /// Builds the default widget for a month item, displaying the month name.
  ///
  /// The month format ('MMMM' or 'MMM') depends on the device width.
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

  /// Builds the widget that displays the currently selected year and month.
  ///
  /// Uses [widget.yearMonthTextBuilder] if provided, otherwise defaults to [YearMonthText].
  Widget _buildYearMonthText() {
    return widget.yearMonthTextBuilder?.call(context, _year, _month) ??
        YearMonthText(locale: widget.locale, year: _year, month: _month);
  }

  /// Builds the year selector UI.
  ///
  /// Includes increment/decrement buttons and a dropdown for year selection.
  Widget _buildYearSelector() {
    final listYears = List<int>.generate(
      Utils.yearsLength(widget.firstYear, widget.lastYear),
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

  /// Builds the month selector UI.
  ///
  /// Displays months in a grid format.
  Widget _buildMonthSelector() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [for (var i = 0; i < 4; i++) _buildMonthRow(i)],
    );
  }

  /// Builds a single row of month buttons for the month selector grid.
  ///
  /// Each row typically contains 3 months.
  /// The [row] parameter is the 0-indexed row number.
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

  /// Builds the action buttons (e.g., "OK", "Cancel") for the dialog.
  ///
  /// Uses [widget.okButtonBuilder] and [widget.cancelButtonBuilder] if provided,
  /// otherwise defaults to standard [TextButton]s with localized labels from [MaterialLocalizations].
  Widget _buildActions(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      spacing: 8.0,
      children: [
        DefaultTextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          label: localizations.cancelButtonLabel,
          childBuilder: widget.cancelButtonBuilder,
        ),
        DefaultTextButton(
          onPressed: () {
            Navigator.of(context).pop(DateTime(_year, _month));
          },
          label: localizations.okButtonLabel,
          childBuilder: widget.okButtonBuilder,
        ),
      ],
    );
  }
}
