import 'datetime_utils.dart';

class DateTimeEntity {
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;
  String? horoscope;

  String? lunarYearName;
  String? lunarMonthName;
  String? lunarDayName;
  String? zodiac;



  DateTimeEntity({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.horoscope,
    this.lunarYearName,
    this.lunarMonthName,
    this.lunarDayName,
    this.zodiac,
  });

  static DateTimeEntity fromDateTime(DateTime dateTime) => DateTimeEntity(
    year: dateTime.year,
    month: dateTime.month,
    day: dateTime.day,
    hour: dateTime.hour,
    minute: dateTime.minute,
    second: dateTime.second,
    lunarYearName: getLunarYearName(dateTime.year),
    lunarMonthName: getLunarMonthName(dateTime.month),
    lunarDayName: getLunarDayName(dateTime.day),
  );
  
}
