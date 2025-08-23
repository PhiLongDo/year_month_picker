import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showYearMonthPickerBottomSheet({
  required BuildContext context,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Locale? locale,
  TextDirection? textDirection,
  required int lastYear,
  required int firstYear,
  DateTime? initialYearMonth,
  Color? backgroundColor,
  Widget Function(BuildContext context, int year)? buildYearItem,
  Widget Function(BuildContext context, int month)? buildMonthItem,
  Widget Function(BuildContext context)? buildOkButton,
  Widget Function(BuildContext context)? buildCancelButton,
  void Function(int year)? onYearChanged,
  void Function(int month)? onMonthChanged,
  bool? showDragHandle,
}) {
  assert(
    lastYear >= firstYear,
    "lastYear must be greater than or equal to firstYear",
  );
  if (initialYearMonth == null) {
    assert(
      lastYear >= DateTime.now().year,
      """lastYear must be greater than or equal to current year when initialYearMonth is null""",
    );
  } else {
    assert(
      lastYear >= initialYearMonth.year,
      "lastYear must be greater than or equal to the year of initialYearMonth",
    );
  }

  Widget bottomSheet = _YearMonthPickerBottomSheet(
    lastYear: lastYear,
    firstYear: firstYear,
    initialYearMonth: initialYearMonth,
    buildMonthItem: buildMonthItem,
    buildCancelButton: buildCancelButton,
    buildOkButton: buildOkButton,
    buildYearItem: buildYearItem,
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
    builder: (BuildContext context) {
      return bottomSheet;
    },
  );
}

class _YearMonthPickerBottomSheet extends StatefulWidget {
  _YearMonthPickerBottomSheet({
    required this.lastYear,
    required this.firstYear,
    this.buildYearItem,
    this.buildMonthItem,
    this.buildOkButton,
    this.buildCancelButton,
    this.onYearChanged,
    this.onMonthChanged,
    DateTime? initialYearMonth,
  }) {
    assert(
      lastYear >= firstYear,
      "lastYear must be greater than or equal to firstYear",
    );
    this.initialYearMonth = initialYearMonth ?? DateTime.now();
    if (initialYearMonth == null) {
      assert(
        lastYear >= DateTime.now().year,
        """lastYear must be greater than or equal to current year when initialYearMonth is null""",
      );
    } else {
      assert(
        lastYear >= initialYearMonth.year,
        "lastYear must be greater than or equal to the year of initialYearMonth",
      );
    }
  }

  final int lastYear;
  final int firstYear;
  late final DateTime initialYearMonth;

  final Widget Function(BuildContext context, int year)? buildYearItem;
  final Widget Function(BuildContext context, int month)? buildMonthItem;
  final Widget Function(BuildContext context)? buildOkButton;
  final Widget Function(BuildContext context)? buildCancelButton;

  final void Function(int year)? onYearChanged;
  final void Function(int month)? onMonthChanged;

  @override
  State<_YearMonthPickerBottomSheet> createState() =>
      _YearMonthPickerBottomSheetState();
}

class _YearMonthPickerBottomSheetState
    extends State<_YearMonthPickerBottomSheet> {
  Widget Function(BuildContext, int year) get _buildYearItem =>
      widget.buildYearItem ?? _defaultBuildItem;

  Widget Function(BuildContext, int month) get _buildMonthItem =>
      widget.buildMonthItem ?? _defaultBuildItem;

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
                  child: widget.buildCancelButton?.call(context) ??
                      Text(localizations.cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(DateTime(_year, _month));
                  },
                  child: widget.buildOkButton?.call(context) ??
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
