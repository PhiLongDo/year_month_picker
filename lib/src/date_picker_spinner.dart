import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:year_month_picker/src/utils.dart';

import 'components/default_text_button.dart';
import 'constants.dart';
import 'validations.dart';

/// Displays a bottom sheet allowing the user to pick a day, month, and year.
///
/// This function shows a modal bottom sheet with three vertical carousels for selecting
/// a day, a month, and a year. It supports UI customization, localization, and callbacks for
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
/// - `initialDate` (optional): The initial date (day, month, year) to display (defaults to now).
/// - `backgroundColor` (optional): Background color of the bottom sheet.
/// - `yearItemBuilder` (optional): Custom builder for year items.
/// - `monthItemBuilder` (optional): Custom builder for month items.
/// - `dayItemBuilder` (optional): Custom builder for day items.
/// - `dateSelectedBuilder` (optional): Custom builder for the selected date.
/// - `okButtonBuilder` (optional): Custom builder for the OK button.
/// - `cancelButtonBuilder` (optional): Custom builder for the Cancel button.
/// - `onYearChanged` (optional): Callback when the year changes.
/// - `onMonthChanged` (optional): Callback when the month changes.
/// - `onDayChanged` (optional): Callback when the day changes.
/// - `showDragHandle` (optional): Whether to show a drag handle on the sheet.
/// - `spinnerHeight` (optional): Height of the spinner (carousel) area. Defaults to `defaultSpinnerHeight`.
///
/// Returns:
/// - `Future<DateTime?>`: Resolves to the selected date (year, month, day) as a `DateTime` if confirmed,
///   or `null` if the user cancels or dismisses the sheet.
Future<DateTime?> showDatePickerSpinner({
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
  DateTime? initialDate,
  Color? backgroundColor,
  Widget Function(BuildContext context, int year)? yearItemBuilder,
  Widget Function(BuildContext context, int month)? monthItemBuilder,
  Widget Function(BuildContext context, int day)? dayItemBuilder,
  Widget Function(BuildContext context, DateTime date)? dateSelectedBuilder,
  Widget Function(BuildContext context)? okButtonBuilder,
  Widget Function(BuildContext context)? cancelButtonBuilder,
  void Function(int year)? onYearChanged,
  void Function(int month)? onMonthChanged,
  void Function(int day)? onDayChanged,
  bool? showDragHandle,
  double spinnerHeight = defaultSpinnerHeight,
}) {
  validateYearMonthPickerParams(
    lastYear: lastYear,
    firstYear: firstYear,
    initialYearMonth: initialDate,
  );

  Widget bottomSheet = _DatePickerSpinner(
    lastYear: lastYear,
    firstYear: firstYear,
    initialDate: initialDate,
    dayItemBuilder: dayItemBuilder,
    monthItemBuilder: monthItemBuilder,
    yearItemBuilder: yearItemBuilder,
    dateSelectedBuilder: dateSelectedBuilder,
    cancelButtonBuilder: cancelButtonBuilder,
    okButtonBuilder: okButtonBuilder,
    onMonthChanged: onMonthChanged,
    onYearChanged: onYearChanged,
    onDayChanged: onDayChanged,
    spinnerHeight: spinnerHeight,
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
  return Utils.showCustomModalBottomSheet<DateTime?>(
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

/// A private [StatefulWidget] that represents the content of the day/month/year picker bottom sheet.
///
/// This widget is responsible for displaying the UI for day, month and year selection using
/// carousels, handling user interactions, and managing the internal state of the selected date.
class _DatePickerSpinner extends StatefulWidget {
  /// Creates an instance of [_DatePickerSpinner].
  ///
  /// Parameters are typically passed from [showDatePickerSpinner].
  _DatePickerSpinner({
    required this.lastYear,
    required this.firstYear,
    this.yearItemBuilder,
    this.monthItemBuilder,
    this.dayItemBuilder,
    this.okButtonBuilder,
    this.cancelButtonBuilder,
    this.dateSelectedBuilder,
    this.onYearChanged,
    this.onMonthChanged,
    this.onDayChanged,
    this.spinnerHeight = defaultSpinnerHeight,
    DateTime? initialDate,
  }) {
    validateYearMonthPickerParams(
      lastYear: lastYear,
      firstYear: firstYear,
      initialYearMonth: initialDate,
    );
    this.initialDate = initialDate ?? DateTime.now();
  }

  /// The maximum selectable year.
  final int lastYear;

  /// The minimum selectable year.
  final int firstYear;

  /// The initially selected year, month, and day.
  /// Defaults to the current date and time if not specified.
  late final DateTime initialDate;

  /// Optional custom builder for year items in the carousel.
  final Widget Function(BuildContext context, int year)? yearItemBuilder;

  /// Optional custom builder for month items in the carousel.
  final Widget Function(BuildContext context, int month)? monthItemBuilder;

  /// Optional custom builder for day items in the carousel.
  final Widget Function(BuildContext context, int day)? dayItemBuilder;

  /// Optional custom builder for the selected date.
  final Widget Function(BuildContext context, DateTime date)?
      dateSelectedBuilder;

  /// Optional custom builder for the OK button.
  final Widget Function(BuildContext context)? okButtonBuilder;

  /// Optional custom builder for the Cancel button.
  final Widget Function(BuildContext context)? cancelButtonBuilder;

  /// Callback invoked when the selected year changes.
  final void Function(int year)? onYearChanged;

  /// Callback invoked when the selected month changes.
  final void Function(int month)? onMonthChanged;

  /// Callback invoked when the selected day changes.
  final void Function(int day)? onDayChanged;

  /// Height of the spinner (carousel) area.
  final double spinnerHeight;

  @override
  State<_DatePickerSpinner> createState() => _DatePickerSpinnerState();
}

/// The state for the [_DatePickerSpinner].
///
/// Manages the currently selected year, month, and day, and builds the UI
/// for the bottom sheet content. It handles user interactions from the carousels
/// and buttons, updating the display and invoking callbacks accordingly.
class _DatePickerSpinnerState extends State<_DatePickerSpinner> {
  /// Returns the effective day item builder.
  ///
  /// Defaults to [_defaultBuildItem] if [widget.dayItemBuilder] is null.
  Widget Function(BuildContext, int day) get _buildDayItem =>
      widget.dayItemBuilder ?? _defaultBuildItem;

  /// Returns the effective year item builder.
  ///
  /// Defaults to [_defaultBuildItem] if [widget.yearItemBuilder] is null.
  Widget Function(BuildContext, int year) get _buildYearItem =>
      widget.yearItemBuilder ?? _defaultBuildItem;

  /// Returns the effective month item builder.
  ///
  /// Defaults to [_defaultBuildItem] if [widget.monthItemBuilder] is null.
  Widget Function(BuildContext, int month) get _buildMonthItem =>
      widget.monthItemBuilder ?? _defaultBuildItem;

  late int _year;
  late int _month;
  late int _day;

  final CarouselSliderController _dayController = CarouselSliderController();
  final CarouselSliderController _monthController = CarouselSliderController();
  final CarouselSliderController _yearController = CarouselSliderController();

  /// Builds the default widget for a carousel item (year or month).
  ///
  /// Displays the [number] centered in a decorated container.
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
    _year = widget.initialDate.year;
    _month = widget.initialDate.month;
    _day = widget.initialDate.day;

    // Notify listeners about the initial state.
    widget.onYearChanged?.call(_year);
    widget.onMonthChanged?.call(_month);
    widget.onDayChanged?.call(_day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultTextButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  label: localizations.cancelButtonLabel,
                  childBuilder: widget.cancelButtonBuilder,
                ),
                widget.dateSelectedBuilder != null
                    ? widget.dateSelectedBuilder!(
                        context,
                        DateTime(_year, _month, _day),
                      )
                    : Text(
                        const GregorianCalendarDelegate().formatShortDate(
                          DateTime(_year, _month, _day),
                          localizations,
                        ),
                      ),
                DefaultTextButton(
                  onPressed: () {
                    Navigator.of(context).pop(DateTime(_year, _month, _day));
                  },
                  label: localizations.okButtonLabel,
                  childBuilder: widget.okButtonBuilder,
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: widget.spinnerHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Day
                Utils.buildCarouselSlider(
                  controller: _dayController,
                  itemCount: DateUtils.getDaysInMonth(_year, _month),
                  initialPage: _day - 1,
                  onPageChanged: (index) => _onDayChanged(index),
                  itemChild: (index) => _buildDayItem(context, index + 1),
                ),

                // Month
                Utils.buildCarouselSlider(
                  controller: _monthController,
                  itemCount: 12,
                  initialPage: _month - 1,
                  onPageChanged: (index) => _onMonthChanged(index),
                  itemChild: (index) => _buildMonthItem(context, index + 1),
                ),

                // Year
                Utils.buildCarouselSlider(
                  controller: _yearController,
                  itemCount:
                      Utils.yearsLength(widget.firstYear, widget.lastYear),
                  initialPage: _year - widget.firstYear,
                  onPageChanged: (index) => _onYearChanged(index),
                  itemChild: (index) {
                    final year = widget.firstYear + index;
                    return _buildYearItem(context, year);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onYearChanged(int index) {
    _year = widget.firstYear + index;
    widget.onYearChanged?.call(_year);

    final daysInMonth = DateUtils.getDaysInMonth(_year, _month);
    if (_day > daysInMonth) {
      _day = daysInMonth;
    }
    setState(() {});
    _dayController.jumpToPage(_day - 1);
  }

  void _onMonthChanged(int index) {
    _month = index + 1;
    widget.onMonthChanged?.call(_month);

    final daysInMonth = DateUtils.getDaysInMonth(_year, _month);
    if (_day > daysInMonth) {
      _day = daysInMonth;
    }
    setState(() {});
    _dayController.jumpToPage(_day - 1);
  }

  void _onDayChanged(int index) {
    _day = index + 1;
    widget.onDayChanged?.call(_day);
    setState(() {});
  }
}
