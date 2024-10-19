import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class YearMonthPicker extends StatefulWidget {
  YearMonthPicker({
    super.key,
    required this.maxYear,
    required this.minYear,
    this.buildYearItem,
    this.buildMonthItem,
    this.backgroundColor = Colors.transparent,
    this.border,
    this.onYearChanged,
    this.onMonthChanged,
    DateTime? initYearMonth,
  }) {
    assert(
      maxYear >= minYear,
      "maxYear must be greater than or equal to minYear",
    );
    this.initYearMonth = initYearMonth ?? DateTime.now();
    if (initYearMonth == null) {
      assert(
        maxYear >= DateTime.now().year,
        """maxYear must be greater than or equal to current year when initYearMonth is null""",
      );
    } else {
      assert(
        maxYear >= initYearMonth.year,
        "maxYear must be greater than or equal to the year of initYearMonth",
      );
    }
  }

  final int maxYear;
  final int minYear;
  late final DateTime initYearMonth;

  final Color? backgroundColor;
  final BoxBorder? border;
  final Widget Function(BuildContext context, int year)? buildYearItem;
  final Widget Function(BuildContext context, int month)? buildMonthItem;

  final void Function(int year)? onYearChanged;
  final void Function(int month)? onMonthChanged;

  @override
  State<YearMonthPicker> createState() => _YearMonthPickerState();
}

class _YearMonthPickerState extends State<YearMonthPicker> {
  final _yearController = CarouselSliderController();
  final _monthController = CarouselSliderController();

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
                carouselController: _monthController,
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
                  carouselController: _yearController,
                  options: CarouselOptions(
                    aspectRatio: constraints.maxWidth / constraints.maxHeight,
                    initialPage:
                        widget.maxYear - widget.minYear + _initYearMonth.year,
                    enlargeFactor: 0.38,
                    viewportFraction: 0.3,
                    scrollDirection: Axis.vertical,
                    enlargeCenterPage: true,
                    onPageChanged: (index, _) {
                      final year = widget.minYear + index;
                      widget.onYearChanged?.call(year);
                    },
                  ),
                  items: List.generate(
                    widget.maxYear - widget.minYear,
                    (index) {
                      final year = widget.minYear + index;
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
