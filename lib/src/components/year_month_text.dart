import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget that displays a formatted year and month.
class YearMonthText extends StatelessWidget {
  /// Creates a [YearMonthText] widget.
  ///
  /// The [year] and [month] parameters are required.
  /// The [locale] parameter is optional and specifies the locale to use for formatting.
  const YearMonthText({
    super.key,
    required int year,
    required int month,
    this.locale,
  })  : _year = year,
        _month = month;

  final int _year;
  final int _month;

  /// The locale to use for formatting the date.
  ///
  /// If null, the default locale is used.
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.yMMMM(locale?.languageCode).format(DateTime(_year, _month)),
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
