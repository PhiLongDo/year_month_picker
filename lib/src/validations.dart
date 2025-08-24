void validateYearMonthPickerParams({
  required int lastYear,
  required int firstYear,
  DateTime? initialYearMonth,
}) {
  assert(
    lastYear >= firstYear,
    "lastYear must be greater than or equal to firstYear",
  );
  if (initialYearMonth == null) {
    assert(
      lastYear >= DateTime.now().year,
      """lastYear must be greater than or equal to current year when initialYearMonth is null""",
    );
  } else {
    assert(
      lastYear >= initialYearMonth.year,
      "lastYear must be greater than or equal to the year of initialYearMonth",
    );
  }
}
