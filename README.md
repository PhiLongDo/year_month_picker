# year_month_picker
[![pub](https://img.shields.io/pub/v/year_month_picker?label=pub&logo=dart)](https://pub.dev/packages/year_month_picker/install)
[![stars](https://img.shields.io/github/stars/PhiLongDo/year_month_picker?logo=github)](https://github.com/PhiLongDo/year_month_picker)
[![issues](https://img.shields.io/github/issues/PhiLongDo/year_month_picker?logo=github)](https://github.com/PhiLongDo/year_month_picker/issues) 

A Flutter package that enables users to select a year and month via a dialog or bottom sheet interface.

---

🚀 **Web Demo:** [https://philongdo.github.io/#/year_month_picker](https://philongdo.github.io/#/year_month_picker)

---

### Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  year_month_picker: ^1.0.2
```

Then, run `flutter pub get` to install the package.

### Importing

Import the package in your Dart code where you want to use it:

```dart
import 'package:year_month_picker/year_month_picker.dart';
```

## Usage

### Show Year-Month Picker Dialog

Use `showYearMonthPickerDialog` to display a dialog for selecting year and month:

```dart
import 'package:year_month_picker/year_month_picker.dart';

// ...existing code...

final selected = await showYearMonthPickerDialog(
  context: context,
  firstYear: 2000,
  lastYear: 2100,
  initialYearMonth: DateTime.now(),
);

// `selected` is a DateTime (year & month) or null if cancelled
```

**Dialog Example:**

![Dialog Screenshot](https://github.com/PhiLongDo/year_month_picker/blob/main/Screenshot/Screenshot_dialog.PNG?raw=true)

### Show Year-Month Picker Bottom Sheet

Use `showYearMonthPickerBottomSheet` to display a bottom sheet picker:

```dart
import 'package:year_month_picker/year_month_picker.dart';

// ...existing code...

final selected = await showYearMonthPickerBottomSheet(
  context: context,
  firstYear: 2000,
  lastYear: 2100,
  initialYearMonth: DateTime.now(),
);

// `selected` is a DateTime (year & month) or null if cancelled
```

**Bottom Sheet Example:**

![Bottom Sheet Screenshot](https://github.com/PhiLongDo/year_month_picker/blob/main/Screenshot/Screenshot_bottom_sheet.PNG?raw=true)

### Customization

Both functions support various customization options:
- `yearItemBuilder`, `monthItemBuilder`: Customize year/month item widgets.
- `okButtonBuilder`, `cancelButtonBuilder`: Customize action buttons.
- `locale`, `textDirection`: Localization and text direction support.
- `onYearChanged`, `onMonthChanged`: Callbacks for selection changes.

See the API documentation for all available parameters.

---

## ☕ Buy Me a Coffee

If you find this package useful, you can support me here:

[![Buy Me A Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&slug=dplong&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff)](https://buymeacoffee.com/dplong)
