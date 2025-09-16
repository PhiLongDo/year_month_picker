## 1.0.1

* Initial release

## 1.0.2

* Fix: Improved dialog performance
    - Replaced the `DropdownButton` with a custom `Dropdown` widget for the year selector in the `YearMonthPickerDialog`.
    - Updated month item builder to use 'MMM' format for device widths <= 412 and 'MMMM' for larger screens.
    - Added a `SizedBox` for spacing below the month selector.