import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YearMonthText extends StatelessWidget {
  const YearMonthText({
    super.key,
    required int year,
    required int month,
    this.locale,
  })  : _year = year,
        _month = month;

  final int _year;
  final int _month;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.yMMMM(locale?.languageCode).format(DateTime(_year, _month)),
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
