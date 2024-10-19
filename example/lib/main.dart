import 'package:flutter/material.dart';
import 'package:year_month_picker/year_month_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: YearMonthPicker(
            maxYear: 3000,
            minYear: 2000,
            initYearMonth: DateTime.now(),
          ),
        ),
      ),
    );
  }
}
