/// Validates the parameters for the year month picker.
///
/// Ensures that [lastYear] is greater than or equal to [firstYear].
/// If [initialYearMonth] is null, it asserts that [lastYear] is greater than or
/// equal to the current year.
/// If [initialYearMonth] is not null, it asserts that [lastYear] is greater than
/// or equal to the year of [initialYearMonth].
///
/// Throws an [AssertionError] if any validation fails.
///
/// Parameters:
/// - [lastYear]: The last selectable year.
/// - [firstYear]: The first selectable year.
/// - [initialYearMonth]: The initially selected year and month. Can be null.
void validateYearMonthPickerParams({
  required int lastYear,
  required int firstYear,
  DateTime? initialYearMonth,
}) {
  assert(
    lastYear >= firstYear,
    'lastYear must be greater than or equal to firstYear',
  );
  if (initialYearMonth == null) {
    assert(
      lastYear >= DateTime.now().year,
      '''lastYear must be greater than or equal to current year when initialYearMonth is null''',
    );
  } else {
    assert(
      lastYear >= initialYearMonth.year,
      'lastYear must be greater than or equal to the year of initialYearMonth',
    );
  }
}
