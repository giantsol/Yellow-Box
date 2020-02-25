
extension IntExtension on int {
  String toYearMonthDateString() {
    final date = DateTime.fromMillisecondsSinceEpoch(this);
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
