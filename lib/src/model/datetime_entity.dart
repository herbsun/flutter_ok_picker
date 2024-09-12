import 'i18n.dart';

class DateTimeEntity {
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;
  LocaleType locale;

  DateTimeEntity({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.locale = LocaleType.en,
  });
}
