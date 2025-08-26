import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'validations.dart';

/// Displays a bottom sheet allowing the user to pick a year and month.
///
/// This function shows a modal bottom sheet with two vertical carousels for selecting
/// a year and a month. It supports UI customization, localization, and callbacks for
/// selection changes. The result is returned asynchronously when the user confirms or
/// cancels the picker.
///
/// Parameters:
/// - `context` (required): The build context to display the bottom sheet.
/// - `lastYear` (required): The maximum selectable year.
/// - `firstYear` (required): The minimum selectable year.
/// - `barrierColor` (optional): The color of the modal barrier behind the sheet.
/// - `barrierLabel` (optional): Accessibility label for the barrier.
/// - `useRootNavigator` (default `true`): Whether to use the root navigator.
/// - `routeSettings` (optional): Route settings for the bottom sheet.
/// - `locale` (optional): Custom locale for the picker.
/// - `textDirection` (optional): Text direction (LTR/RTL).
/// - `anchorPoint` (optional): The anchor point for the bottom sheet position.
/// - `initialYearMonth` (optional): The initial year and month to display (defaults to now).
/// - `backgroundColor` (optional): Background color of the bottom sheet.
/// - `yearItemBuilder` (optional): Custom builder for year items.
/// - `monthItemBuilder` (optional): Custom builder for month items.
/// - `okButtonBuilder` (optional): Custom builder for the OK button.
/// - `cancelButtonBuilder` (optional): Custom builder for the Cancel button.
/// - `onYearChanged` (optional): Callback when the year changes.
/// - `onMonthChanged` (optional): Callback when the month changes.
/// - `showDragHandle` (optional): Whether to show a drag handle on the sheet.
///
/// Returns:
/// - `Future<DateTime?>`: Resolves to the selected year and month as a `DateTime` if confirmed,
///   or `null` if the user cancels or dismisses the sheet.
Future<DateTime?> showYearMonthPickerBottomSheet({
  required BuildContext context,
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
  void Function(int year)? onYearChanged,
  void Function(int month)? onMonthChanged,
  bool? showDragHandle,
}) {
  validateYearMonthPickerParams(
    lastYear: lastYear,
    firstYear: firstYear,
    initialYearMonth: initialYearMonth,
  );

  Widget bottomSheet = _YearMonthPickerBottomSheet(
    lastYear: lastYear,
    firstYear: firstYear,
    initialYearMonth: initialYearMonth,
    monthItemBuilder: monthItemBuilder,
    cancelButtonBuilder: cancelButtonBuilder,
    okButtonBuilder: okButtonBuilder,
    yearItemBuilder: yearItemBuilder,
    onMonthChanged: onMonthChanged,
    onYearChanged: onYearChanged,
  );

  if (textDirection != null) {
    bottomSheet =
        Directionality(textDirection: textDirection, child: bottomSheet);
  }
  if (locale != null) {
    bottomSheet = Localizations.override(
      context: context,
      locale: locale,
      child: bottomSheet,
    );
  }
  return showModalBottomSheet<DateTime?>(
    context: context,
    useSafeArea: true,
    showDragHandle: showDragHandle,
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    builder: (BuildContext context) {
      return bottomSheet;
    },
  );
}

class _YearMonthPickerBottomSheet extends StatefulWidget {
  _YearMonthPickerBottomSheet({
    required this.lastYear,
    required this.firstYear,
    this.yearItemBuilder,
    this.monthItemBuilder,
    this.okButtonBuilder,
    this.cancelButtonBuilder,
    this.onYearChanged,
    this.onMonthChanged,
    DateTime? initialYearMonth,
  }) {
    validateYearMonthPickerParams(
      lastYear: lastYear,
      firstYear: firstYear,
      initialYearMonth: initialYearMonth,
    );
    this.initialYearMonth = initialYearMonth ?? DateTime.now();
  }

  final int lastYear;
  final int firstYear;
  late final DateTime initialYearMonth;

  final Widget Function(BuildContext context, int year)? yearItemBuilder;
  final Widget Function(BuildContext context, int month)? monthItemBuilder;
  final Widget Function(BuildContext context)? okButtonBuilder;
  final Widget Function(BuildContext context)? cancelButtonBuilder;

  final void Function(int year)? onYearChanged;
  final void Function(int month)? onMonthChanged;

  @override
  State<_YearMonthPickerBottomSheet> createState() =>
      _YearMonthPickerBottomSheetState();
}

class _YearMonthPickerBottomSheetState
    extends State<_YearMonthPickerBottomSheet> {
  Widget Function(BuildContext, int year) get _buildYearItem =>
      widget.yearItemBuilder ?? _defaultBuildItem;

  Widget Function(BuildContext, int month) get _buildMonthItem =>
      widget.monthItemBuilder ?? _defaultBuildItem;

  DateTime get _initYearMonth => widget.initialYearMonth;

  late int _year;
  late int _month;

  Widget _defaultBuildItem(BuildContext context, int number) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          '$number',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 18,
          ),
        ),
      );

  @override
  void initState() {
    _year = _initYearMonth.year;
    _month = _initYearMonth.month;
    widget.onYearChanged?.call(_year);
    widget.onMonthChanged?.call(_month);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                )
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio:
                            constraints.maxWidth / constraints.maxHeight,
                        initialPage: _initYearMonth.month - 1,
                        enlargeFactor: 0.38,
                        viewportFraction: 0.3,
                        scrollDirection: Axis.vertical,
                        enlargeCenterPage: true,
                        onPageChanged: (index, _) {
                          _month = index + 1;
                          widget.onMonthChanged?.call(_month);
                        },
                      ),
                      items: List.generate(
                        12,
                        (index) => _buildMonthItem(context, index + 1),
                      ),
                    );
                  }),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio:
                              constraints.maxWidth / constraints.maxHeight,
                          initialPage: _initYearMonth.year - widget.firstYear,
                          enlargeFactor: 0.38,
                          viewportFraction: 0.3,
                          scrollDirection: Axis.vertical,
                          enlargeCenterPage: true,
                          onPageChanged: (index, _) {
                            _year = widget.firstYear + index;
                            widget.onYearChanged?.call(_year);
                          },
                        ),
                        items: List.generate(
                          widget.lastYear - widget.firstYear,
                          (index) {
                            final year = widget.firstYear + index;
                            return _buildYearItem(context, year);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
