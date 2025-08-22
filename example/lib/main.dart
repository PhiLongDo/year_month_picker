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
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: PreviewWidget()),
      ),
    );
  }
}

class PreviewWidget extends StatelessWidget {
  const PreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        ElevatedButton(
          onPressed: () {
            showYearMonthPickerBottomSheet(
              context: context,
              maxYear: 3000,
              minYear: 2000,
            );
          },
          child: const Text('Show bottom sheet'),
        ),
      ],
    );
  }
}
