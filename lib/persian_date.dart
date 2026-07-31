/// تبدیل ساده‌ی تاریخ میلادی به شمسی، بدون نیاز به پکیج جانبی
class PersianDate {
  static const List<String> monthNames = [
    'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
    'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'
  ];

  static const List<String> weekDays = [
    'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه', 'شنبه', 'یکشنبه'
  ];

  final int year;
  final int month;
  final int day;

  PersianDate(this.year, this.month, this.day);

  static PersianDate fromGregorian(DateTime date) {
    final gy = date.year;
    final gm = date.month;
    final gd = date.day;

    final gDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    int gy2 = (gm > 2) ? (gy + 1) : gy;
    int days = 355666 +
        (365 * gy) +
        ((gy2 + 3) ~/ 4) -
        ((gy2 + 99) ~/ 100) +
        ((gy2 + 399) ~/ 400) +
        gd +
        gDaysInMonth.sublist(0, gm - 1).fold(0, (a, b) => a + b);

    int jy = -1595 + (33 * (days ~/ 12053));
    days %= 12053;
    jy += 4 * (days ~/ 1461);
    days %= 1461;
    if (days > 365) {
      jy += (days - 1) ~/ 365;
      days = (days - 1) % 365;
    }

    int jm;
    int jd;
    if (days < 186) {
      jm = 1 + (days ~/ 31);
      jd = 1 + (days % 31);
    } else {
      jm = 7 + ((days - 186) ~/ 30);
      jd = 1 + ((days - 186) % 30);
    }

    return PersianDate(jy, jm, jd);
  }

  String get monthName => monthNames[month - 1];

  String get formatted => '$day $monthName $year';

  static String weekDayName(DateTime date) {
    // در دارت: Monday=1 ... Sunday=7
    return weekDays[date.weekday - 1];
  }

  /// تبدیل تاریخ شمسی به میلادی (برای ساخت تقویم)
  static DateTime toGregorian(int jy, int jm, int jd) {
    final guess =
        DateTime(jy + 621, 3, 21).add(Duration(days: (jm - 1) * 30 + jd - 1));
    for (int offset = -12; offset <= 12; offset++) {
      final candidate = guess.add(Duration(days: offset));
      final pd = PersianDate.fromGregorian(candidate);
      if (pd.year == jy && pd.month == jm && pd.day == jd) return candidate;
    }
    return guess;
  }

  /// تعداد روزهای یک ماه شمسی خاص
  static int daysInMonth(int jy, int jm) {
    final nextMonth = jm == 12 ? 1 : jm + 1;
    final nextYear = jm == 12 ? jy + 1 : jy;
    final firstOfThis = toGregorian(jy, jm, 1);
    final firstOfNext = toGregorian(nextYear, nextMonth, 1);
    return firstOfNext.difference(firstOfThis).inDays;
  }

  /// اندیس روز هفته برای اولین روز ماه (۰=شنبه ... ۶=جمعه)
  static int firstWeekdayIndex(int jy, int jm) {
    final firstDay = toGregorian(jy, jm, 1);
    final w = firstDay.weekday; // Monday=1 ... Sunday=7
    return (w - 6 + 7) % 7;
  }
}
