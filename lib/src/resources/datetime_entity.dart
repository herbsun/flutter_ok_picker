
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
  String? lunarHourName;
  String? lunarMinuteName;
  String? lunarSecondName;
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
    this.lunarHourName,
    this.lunarMinuteName,
    this.lunarSecondName,
    this.zodiac,
  });

  static DateTimeEntity fromDateTime(DateTime dateTime) => DateTimeEntity(
    year: dateTime.year,
    month: dateTime.month,
    day: dateTime.day,
    hour: dateTime.hour,
    minute: dateTime.minute,
    second: dateTime.second,
  );
  
}
