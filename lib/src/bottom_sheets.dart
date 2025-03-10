import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showYearMonthPickerBottomSheet({
  required BuildContext context,
  required DateTime maxYearMonth,
  required DateTime minYearMonth,
  DateTime? initYearMonth,
  Color? backgroundColor,
  BoxBorder? border,
  Widget Function(BuildContext context, int year)? buildYearItem,
  Widget Function(BuildContext context, int month)? buildMonthItem,
  void Function(int year)? onYearChanged,
  void Function(int month)? onMonthChanged,
}) {
  late int year;
  late int month;

  return showModalBottomSheet<DateTime?>(
    context: context,
    useSafeArea: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: 250,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: const Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(DateTime(year, month));
                    },
                    child: const Text('Chọn'),
                  )
                ],
              ),
            ),
            YearMonthPickerBottomSheet(
              maxYearMonth: maxYearMonth,
              minYearMonth: minYearMonth,
              initYearMonth: initYearMonth,
              backgroundColor: backgroundColor,
              border: border,
              buildMonthItem: buildMonthItem,
              buildYearItem: buildYearItem,
              onMonthChanged: (value) {
                month = value;
                onMonthChanged?.call(month);
              },
              onYearChanged: (value) {
                year = value;
                onYearChanged?.call(year);
              },
            ),
          ],
        ),
      );
    },
  );
}

class YearMonthPickerBottomSheet extends StatefulWidget {
  YearMonthPickerBottomSheet({
    super.key,
    required this.maxYearMonth,
    required this.minYearMonth,
    this.buildYearItem,
    this.buildMonthItem,
    this.backgroundColor = Colors.transparent,
    this.border,
    this.onYearChanged,
    this.onMonthChanged,
    DateTime? initYearMonth,
  }) {
    assert(
      maxYearMonth.year >= minYearMonth.year,
      "maxYear must be greater than or equal to minYear",
    );
    this.initYearMonth = initYearMonth ?? DateTime.now();
    if (initYearMonth == null) {
      assert(
        maxYearMonth.year >= DateTime.now().year,
        """maxYear must be greater than or equal to current year when initYearMonth is null""",
      );
    } else {
      assert(
        maxYearMonth.year >= initYearMonth.year,
        "maxYear must be greater than or equal to the year of initYearMonth",
      );
    }
  }

  final DateTime maxYearMonth;
  final DateTime minYearMonth;
  late final DateTime initYearMonth;

  final Color? backgroundColor;
  final BoxBorder? border;
  final Widget Function(BuildContext context, int year)? buildYearItem;
  final Widget Function(BuildContext context, int month)? buildMonthItem;

  final void Function(int year)? onYearChanged;
  final void Function(int month)? onMonthChanged;

  @override
  State<YearMonthPickerBottomSheet> createState() =>
      _YearMonthPickerBottomSheetState();
}

class _YearMonthPickerBottomSheetState
    extends State<YearMonthPickerBottomSheet> {
  Widget Function(BuildContext, int year) get _buildYearItem =>
      widget.buildYearItem ?? _defaultBuildItem;

  Widget Function(BuildContext, int month) get _buildMonthItem =>
      widget.buildMonthItem ?? _defaultBuildItem;

  DateTime get _initYearMonth => widget.initYearMonth;

  Widget _defaultBuildItem(BuildContext context, int number) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          '$number',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );

  @override
  void initState() {
    widget.onYearChanged?.call(_initYearMonth.year);
    widget.onMonthChanged?.call(_initYearMonth.month);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: widget.border,
        color: widget.backgroundColor,
      ),
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: constraints.maxWidth / constraints.maxHeight,
                  initialPage: _initYearMonth.month - 1,
                  enlargeFactor: 0.38,
                  viewportFraction: 0.3,
                  scrollDirection: Axis.vertical,
                  enlargeCenterPage: true,
                  onPageChanged: (index, _) {
                    final month = index + 1;
                    widget.onMonthChanged?.call(month);
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
                    aspectRatio: constraints.maxWidth / constraints.maxHeight,
                    initialPage: _initYearMonth.year - widget.minYearMonth.year,
                    enlargeFactor: 0.38,
                    viewportFraction: 0.3,
                    scrollDirection: Axis.vertical,
                    enlargeCenterPage: true,
                    onPageChanged: (index, _) {
                      final year = widget.minYearMonth.year + index;
                      widget.onYearChanged?.call(year);
                    },
                  ),
                  items: List.generate(
                    widget.maxYearMonth.year - widget.minYearMonth.year,
                    (index) {
                      final year = widget.minYearMonth.year + index;
                      return _buildYearItem(context, year);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
