import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:year_month_picker_example/date_spinner_preview.dart';

import 'bottom_sheet_preview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dialog_preview.dart';

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
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 24,
                children: [
                  yearMonthSelected != null
                      ? Text(DateFormat.yMd().format(yearMonthSelected!))
                      : const Text('No data'),
                  BottomSheetPreview(
                    initYearMonth: yearMonthSelected,
                    onYearMonthSelected: (dateTime) {
                      setState(() {
                        yearMonthSelected = dateTime;
                      });
                    },
                  ),
                  DialogPreview(
                    initYearMonth: yearMonthSelected,
                    onYearMonthSelected: (dateTime) {
                      setState(() {
                        yearMonthSelected = dateTime;
                      });
                    },
                  ),
                  DateSpinnerPreview(
                    initDate: yearMonthSelected,
                    onDateSelected: (dateTime) {
                      setState(() {
                        yearMonthSelected = dateTime;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
