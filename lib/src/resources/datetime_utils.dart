import 'package:lunar/lunar.dart';

String fillPrefixZero(int v) => v <= 9 ? '0$v' : '$v';

String getLunarYearName(int year) {
  String y = year.toString();
  String s = '';
  for (int i = 0, j = y.length; i < j; i++) {
    s += LunarUtil.NUMBER[y.codeUnitAt(i) - 48];
  }
  return s;
}

String getLunarMonthName(int month) => (month < 0 ? '闰' : '') + LunarUtil.MONTH[month.abs()];
String getLunarDayName(int day) => (day < 0 ? '闰' : '') + LunarUtil.DAY[day.abs()];

int getDays({required int month, int? year}) {
  List<int> leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

  if (leapYearMonths.contains(month)) {
    return 31;
  } else if (month == 2) {
    if (year == null || ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) ) {
      return 29;
    }
    return 28;
  }
  return 30;
}
