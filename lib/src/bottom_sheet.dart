import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:year_month_picker/src/utils.dart';

import 'components/default_text_button.dart';
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

/// A private [StatefulWidget] that represents the content of the year/month picker bottom sheet.
///
/// This widget is responsible for displaying the UI for year and month selection using
/// carousels, handling user interactions, and managing the internal state of the selected date.
class _YearMonthPickerBottomSheet extends StatefulWidget {
  /// Creates an instance of [_YearMonthPickerBottomSheet].
  ///
  /// Parameters are typically passed from [showDatePickerSpinner].
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

  /// The maximum selectable year.
  final int lastYear;

  /// The minimum selectable year.
  final int firstYear;

  /// The initially selected year and month.
  /// Defaults to the current date and time if not specified.
  late final DateTime initialYearMonth;

  /// Optional custom builder for year items in the carousel.
  final Widget Function(BuildContext context, int year)? yearItemBuilder;

  /// Optional custom builder for month items in the carousel.
  final Widget Function(BuildContext context, int month)? monthItemBuilder;

  /// Optional custom builder for the OK button.
  final Widget Function(BuildContext context)? okButtonBuilder;

  /// Optional custom builder for the Cancel button.
  final Widget Function(BuildContext context)? cancelButtonBuilder;

  /// Callback invoked when the selected year changes.
  final void Function(int year)? onYearChanged;

  /// Callback invoked when the selected month changes.
  final void Function(int month)? onMonthChanged;

  @override
  State<_YearMonthPickerBottomSheet> createState() =>
      _YearMonthPickerBottomSheetState();
}

/// The state for the [_YearMonthPickerBottomSheet].
///
/// Manages the currently selected year and month, and builds the UI
/// for the bottom sheet content. It handles user interactions from the carousels
/// and buttons, updating the display and invoking callbacks accordingly.
class _YearMonthPickerBottomSheetState
    extends State<_YearMonthPickerBottomSheet> {
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

  /// Gets the initial year and month from the widget.
  DateTime get _initYearMonth => widget.initialYearMonth;

  late int _year;
  late int _month;

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
    _year = _initYearMonth.year;
    _month = _initYearMonth.month;
    // Notify listeners about the initial state.
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
                )
              ],
            ),
          ),
          const Divider(),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 180),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return CarouselSlider(
                      carouselController: _monthController,
                      options: _createCarouselOptions(
                        aspectRatio:
                            constraints.maxWidth / constraints.maxHeight,
                        initialPage: _initYearMonth.month - 1,
                        onPageChanged: (index, _) {
                          _month = index + 1;
                          widget.onMonthChanged?.call(_month);
                        },
                      ),
                      items: List.generate(
                        12,
                        (index) => GestureDetector(
                          onTap: () {
                            _monthController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 200),
                            );
                          },
                          child: _buildMonthItem(context, index + 1),
                        ),
                      ),
                    );
                  }),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CarouselSlider(
                        carouselController: _yearController,
                        options: _createCarouselOptions(
                          aspectRatio:
                              constraints.maxWidth / constraints.maxHeight,
                          initialPage: _initYearMonth.year - widget.firstYear,
                          onPageChanged: (index, _) {
                            _year = widget.firstYear + index;
                            widget.onYearChanged?.call(_year);
                          },
                        ),
                        items: List.generate(
                          Utils.yearsLength(widget.firstYear, widget.lastYear),
                          (index) {
                            final year = widget.firstYear + index;
                            return GestureDetector(
                              onTap: () {
                                _yearController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 200),
                                );
                              },
                              child: _buildYearItem(context, year),
                            );
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

  CarouselOptions _createCarouselOptions({
    required int initialPage,
    required double aspectRatio,
    required Function(int index, CarouselPageChangedReason reason)
        onPageChanged,
  }) {
    return CarouselOptions(
      aspectRatio: aspectRatio,
      initialPage: initialPage,
      enlargeFactor: 0.38,
      viewportFraction: 0.3,
      scrollDirection: Axis.vertical,
      enlargeCenterPage: true,
      onPageChanged: onPageChanged,
    );
  }
}
