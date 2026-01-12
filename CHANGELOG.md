## 1.0.1

* Initial release

## 1.0.2

* Fix: Improved dialog performance
    - Replaced the `DropdownButton` with a custom `Dropdown` widget for the year selector in the `YearMonthPickerDialog`.
    - Updated month item builder to use 'MMM' format for device widths <= 412 and 'MMMM' for larger screens.
    - Added a `SizedBox` for spacing below the month selector.

## 1.0.3
### Added
- Added `showDatePickerSpinner` function to support displaying a bottom sheet for selecting year and month.

### Fixed
- Fixed an issue where the picker was not displayed correctly in landscape mode ([#7](https://github.com/PhiLongDo/year_month_picker/issues/7))

