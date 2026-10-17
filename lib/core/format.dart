// Lightweight date helpers — avoids pulling in a formatting dependency.

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String shortDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';

String dateRange(DateTime start, DateTime end) {
  if (start.year == end.year && start.month == end.month) {
    return '${start.day}–${end.day} ${_months[start.month - 1]} ${start.year}';
  }
  if (start.year == end.year) {
    return '${shortDate(start)} – ${shortDate(end)} ${start.year}';
  }
  return '${shortDate(start)} ${start.year} – ${shortDate(end)} ${end.year}';
}

String countLabel(int count, String singular, [String? plural]) {
  final word = count == 1 ? singular : (plural ?? '${singular}s');
  return '$count $word';
}
