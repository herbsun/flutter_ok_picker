import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ok_datetime_picker_style.dart';
import 'resources/datetime_entity.dart';
import 'resources/datetime_utils.dart';

enum DateTimeItem { year, month, day, hour, minute, second }

typedef OkDateTimePickerValueCallback = void Function(DateTimeEntity dateTime);
typedef OkDateTimePickerCancelCallback = void Function();

class OkDateTimePicker {
  ///
  /// Display DateTime Picker BottomSheet
  /// Use displayItems to Control which items to display
  /// ```dart
  /// OkDateTimePicker.show(
  ///   context,
  ///   displayItems: [DateTimeItem.year, DateTimeItem.month, DateTimeItem.day],
  ///   allowNullItems: [DateTimeItem.year],
  /// );
  /// ```
  /// Using allowNullItems to Control which items can be select null value
  ///
  static Future<DateTime?> show(
    BuildContext context, {
    required List<DateTimeItem> displayItems,
    List<DateTimeItem>? allowNullItems,
    DateTime? initialTime,
    DateTime? minTime,
    DateTime? maxTime,
    bool? use24hFormat,
    bool? useLunarCalendar,
    OkDateTimePickerStyle? style,
    OkDateTimePickerValueCallback? onChanged,
    OkDateTimePickerCancelCallback? onCanceled,
    OkDateTimePickerValueCallback? onConfirmed,
  }) async {
    return showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return OkDateTimePickerWidget(
          displayItems: displayItems,
          allowNullItems: allowNullItems,
          initialTime: initialTime,
          minTime: minTime,
          maxTime: maxTime,
          use24hFormat: use24hFormat ?? true,
          useLunarCalendar: useLunarCalendar ?? false,
          style: style ?? OkDateTimePickerStyle.light,
          onChanged: onChanged,
          onCanceled: () {
            Navigator.of(context).pop();
            if (onCanceled != null) {
              onCanceled();
            }
          },
          onConfirmed: (DateTimeEntity dateTime) {
            Navigator.of(context).pop();
            if (onConfirmed != null) {
              onConfirmed(dateTime);
            }
          },
        );
      },
    );
  }

  static Widget builder({
    required List<DateTimeItem> displayItems,
    List<DateTimeItem>? allowNullItems,
    DateTime? initialTime,
    DateTime? minTime,
    DateTime? maxTime,
    bool? use24hFormat,
    bool? useLunarCalendar,
    OkDateTimePickerStyle? style,
    OkDateTimePickerValueCallback? onChanged,
    OkDateTimePickerCancelCallback? onCanceled,
    OkDateTimePickerValueCallback? onConfirmed,
  }) {
    return OkDateTimePickerWidget(
      displayItems: displayItems,
      allowNullItems: allowNullItems,
      initialTime: initialTime,
      minTime: minTime,
      maxTime: maxTime,
      use24hFormat: use24hFormat ?? true,
      useLunarCalendar: useLunarCalendar ?? false,
      style: style ?? OkDateTimePickerStyle.light,
      onCanceled: onCanceled,
      onChanged: onChanged,
      onConfirmed: onConfirmed,
    );
  }
}

///
/// OkDateTimePickerWidget
///
class OkDateTimePickerWidget extends StatefulWidget {
  const OkDateTimePickerWidget({
    Key? key,
    required this.displayItems,
    this.allowNullItems,
    this.initialTime,
    this.minTime,
    this.maxTime,
    this.use24hFormat = true,
    this.useLunarCalendar = false,
    OkDateTimePickerStyle? style,
    this.onChanged,
    this.onCanceled,
    this.onConfirmed,
  })  : style = style ?? OkDateTimePickerStyle.light,
        super(key: key);

  /// Use displayItems to Control which items to display
  final List<DateTimeItem> displayItems;

  /// Using allowNullItems to Control which items can be select null value
  final List<DateTimeItem>? allowNullItems;
  final DateTime? initialTime;
  final DateTime? minTime;
  final DateTime? maxTime;
  final bool use24hFormat;
  final bool useLunarCalendar;
  final OkDateTimePickerStyle style;
  final OkDateTimePickerValueCallback? onChanged;
  final OkDateTimePickerValueCallback? onConfirmed;
  final OkDateTimePickerCancelCallback? onCanceled;

  @override
  State<OkDateTimePickerWidget> createState() => _OkDateTimePickerWidgetState();
}

class _PickerItem {
  final int value;
  final String title;

  _PickerItem({required this.value, required this.title});
}

class _OkDateTimePickerWidgetState extends State<OkDateTimePickerWidget> {
  DateTimeEntity selectedDateTime = DateTimeEntity();

  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController secondController;

  late List<_PickerItem> _years;
  late List<_PickerItem> _months;
  late List<_PickerItem> _days;
  late List<_PickerItem> _hours;
  late List<_PickerItem> _minutes;
  late List<_PickerItem> _seconds;

  @override
  void initState() {
    super.initState();
    selectedDateTime =
        DateTimeEntity.fromDateTime(widget.initialTime ?? DateTime.now());
    _initRanges();
    _initControllers();
  }

  void _initRanges() {
    _years = _getYearRange();
    _months = _getMonthRange();
    _days = _getDayRange();
    _hours = _getHourRange();
    _minutes = _getMinuteRange();
    _seconds = _getSecondRange();
  }

  void _initControllers() {
    DateTime initialDt = widget.initialTime ?? DateTime.now();

    // Year
    int yearIdx = _years.indexWhere((ele) => ele.value == initialDt.year);
    yearController = FixedExtentScrollController(
        initialItem: yearIdx < 0 ? _years.length - 1 : yearIdx);

    // Month
    int monthIdx =
        _months.indexWhere((ele) => ele.value == initialDt.month);
    monthController = FixedExtentScrollController(initialItem: max(0, monthIdx));

    // Day
    int dayIdx = _days.indexWhere((ele) => ele.value == initialDt.day);
    dayController = FixedExtentScrollController(initialItem: max(0, dayIdx));

    // Hour
    int hourIdx = _hours.indexWhere((ele) => ele.value == initialDt.hour);
    hourController = FixedExtentScrollController(initialItem: max(0, hourIdx));

    // Minute
    int minuteIdx =
        _minutes.indexWhere((ele) => ele.value == initialDt.minute);
    minuteController =
        FixedExtentScrollController(initialItem: max(0, minuteIdx));

    // Second
    int secondIdx =
        _seconds.indexWhere((ele) => ele.value == initialDt.second);
    secondController =
        FixedExtentScrollController(initialItem: max(0, secondIdx));
  }

  @override
  void dispose() {
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    super.dispose();
  }

  void _onDateTimeChanged(DateTimeItem item, int index) {
    switch (item) {
      case DateTimeItem.year:
        int itemValue = _years[index].value;
        selectedDateTime.year = itemValue == -1 ? null : itemValue;
        selectedDateTime.lunarYearName = itemValue == -1 ? null : getLunarYearName(itemValue);
        break;
      case DateTimeItem.month:
        int itemValue = _months[index].value;
        selectedDateTime.month = itemValue == -1 ? null : itemValue;
        selectedDateTime.lunarMonthName = itemValue == -1 ? null : getLunarMonthName(itemValue);
        break;
      case DateTimeItem.day:
        int itemValue = _days[index].value;
        selectedDateTime.day = itemValue == -1 ? null : itemValue;
        selectedDateTime.lunarDayName = itemValue == -1 ? null : getLunarDayName(itemValue);
        break;
      case DateTimeItem.hour:
        int itemValue = _hours[index].value;
        selectedDateTime.hour = itemValue == -1 ? null : itemValue;
        break;
      case DateTimeItem.minute:
        int itemValue = _minutes[index].value;
        selectedDateTime.minute = itemValue == -1 ? null : itemValue;
        break;
      case DateTimeItem.second:
        int itemValue = _seconds[index].value;
        selectedDateTime.second = itemValue == -1 ? null : itemValue;
        break;
    }
    if (selectedDateTime.day != null && selectedDateTime.day! > 28) {
      if (widget.displayItems.contains(DateTimeItem.month) && widget.displayItems.contains(DateTimeItem.day)) {
        if (selectedDateTime.month != null && selectedDateTime.day != null) {
          int maxDays = getDays(month: selectedDateTime.month!, year: selectedDateTime.year);
          if (selectedDateTime.day! > maxDays) {
            selectedDateTime.day = maxDays;
            Future.delayed(const Duration(milliseconds: 500), () {
              dayController.animateToItem(
                maxDays - 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
              );
            });
          }
        }
      }
    }
  }

  DateTimeEntity _getSelectedDateTime() {
    return selectedDateTime;
  }

  bool isValidSelection(DateTime selectedTime) {
    if (widget.minTime != null && selectedTime.isBefore(widget.minTime!)) {
      return false;
    }
    if (widget.maxTime != null && selectedTime.isAfter(widget.maxTime!)) {
      return false;
    }
    return true;
  }

  List<_PickerItem> _getYearRange() {
    int startYear = widget.minTime?.year ?? 1900;
    int endYear = widget.maxTime?.year ?? 2100;
    List<_PickerItem> years = [];

    for (int i = startYear; i <= endYear; i++) {
      String itemTitle = '$i年';
      if (widget.useLunarCalendar) {
        itemTitle = getLunarYearName(i);
      }
      years.add(_PickerItem(value: i, title: itemTitle));
    }

    if (widget.allowNullItems?.contains(DateTimeItem.year) ?? false) {
      years.add(_PickerItem(value: -1, title: '----'));
    }
    return years;
  }

  List<_PickerItem> _getMonthRange() {
    List<_PickerItem> months = [];

    for (int i = 1; i <= 12; i++) {
      String itemTitle = '$i月';
      if (widget.useLunarCalendar) {
        itemTitle = '${getLunarMonthName(i)}月';
      }
      months.add(_PickerItem(value: i, title: itemTitle));
    }

    if (widget.allowNullItems?.contains(DateTimeItem.month) ?? false) {
      months.add(_PickerItem(value: -1, title: '--'));
    }

    return months;
  }

  List<_PickerItem> _getDayRange() {
    List<_PickerItem> days = [];

    int maxDay = widget.useLunarCalendar ? 30 : 31;

    for (int i = 1; i <= maxDay; i++) {
      String itemTitle = '$i日';
      if (widget.useLunarCalendar) {
        itemTitle = getLunarDayName(i);
      }
      days.add(_PickerItem(value: i, title: itemTitle));
    }

    if (widget.allowNullItems?.contains(DateTimeItem.day) ?? false) {
      days.add(_PickerItem(value: -1, title: '--'));
    }

    return days;
  }

  List<_PickerItem> _getHourRange() {
    List<_PickerItem> hours = [];
    int totalHour = widget.use24hFormat ? 24 : 12;
    for (int i = 0; i < totalHour; i++) {
      String itemValue = '${fillPrefixZero(i)}时';
      hours.add(_PickerItem(value: i, title: itemValue));
    }

    if (widget.allowNullItems?.contains(DateTimeItem.hour) ?? false) {
      hours.add(_PickerItem(value: -1, title: '--'));
    }
    return hours;
  }

  List<_PickerItem> _getMinuteRange() {
    List<_PickerItem> minutes = [];
    for (int i = 0; i < 60; i++) {
      String itemValue = '${fillPrefixZero(i)}分';
      minutes.add(_PickerItem(value: i, title: itemValue));
    }

    if (widget.allowNullItems?.contains(DateTimeItem.minute) ?? false) {
      minutes.add(_PickerItem(value: -1, title: '--'));
    }
    return minutes;
  }

  List<_PickerItem> _getSecondRange() {
    List<_PickerItem> seconds = [];
    for (int i = 0; i < 60; i++) {
      String itemValue = '${fillPrefixZero(i)}秒';
      seconds.add(_PickerItem(value: i, title: itemValue));
    }

    if (widget.allowNullItems?.contains(DateTimeItem.second) ?? false) {
      seconds.add(_PickerItem(value: -1, title: '--'));
    }
    return seconds;
  }

  Widget _buildTimeColumn(DateTimeItem item) {
    List<_PickerItem> items;
    FixedExtentScrollController controller;

    switch (item) {
      case DateTimeItem.year:
        items = _years;
        controller = yearController;
        break;
      case DateTimeItem.month:
        items = _months;
        controller = monthController;
        break;
      case DateTimeItem.day:
        items = _days;
        controller = dayController;
        break;
      case DateTimeItem.hour:
        items = _hours;
        controller = hourController;
        break;
      case DateTimeItem.minute:
        items = _minutes;
        controller = minuteController;
        break;
      case DateTimeItem.second:
        items = _seconds;
        controller = secondController;
        break;
      default:
        items = [];
        // This case should not happen if displayItems is handled correctly
        // But we need a fallback controller
        controller = FixedExtentScrollController();
    }

    return Expanded(
      // ListWheelScrollView
      child: CupertinoPicker(
        looping: item == DateTimeItem.year ? false : true,
        scrollController: controller,
        itemExtent: 40.0,
        children: items.map((item) {
          return Center(
            child: Text(
              item.title,
              style: widget.style.selectedTextStyle,
            ),
          );
        }).toList(),
        onSelectedItemChanged: (int index) {
          _onDateTimeChanged(item, index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.style.pickerHeight + 80,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  widget.onCanceled?.call();
                },
                child: Text('取消', style: widget.style.cancelButtonTextStyle),
              ),
              TextButton(
                onPressed: () {
                  widget.onConfirmed?.call(_getSelectedDateTime());
                },
                child: Text('确认', style: widget.style.confirmButtonTextStyle),
              ),
            ],
          ),
          SizedBox(
            height: widget.style.pickerHeight,
            child: Row(
              children: widget.displayItems.map((item) => _buildTimeColumn(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
