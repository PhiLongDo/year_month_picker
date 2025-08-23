import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bottom_sheet_preview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? yearMonthSelected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('vi', 'VN'), // Hebrew
      ],
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              yearMonthSelected != null
                  ? Text(DateFormat.yMMMM().format(yearMonthSelected!))
                  : const Text('No data'),
              BottomSheetPreview(
                initYearMonth: yearMonthSelected,
                onYearMonthSelected: (dateTime) {
                  setState(() {
                    yearMonthSelected = dateTime;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
