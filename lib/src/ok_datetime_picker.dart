import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunar/lunar.dart';

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
  OkDateTimePickerWidget({
    Key? key,
    required this.displayItems,
    this.allowNullItems,
    this.initialTime,
    this.minTime,
    this.maxTime,
    this.use24hFormat = true,
    this.useLunarCalendar = false,
    this.style,
    this.onChanged,
    this.onCanceled,
    this.onConfirmed,
  }) : super(key: key) {
    assert(displayItems.isNotEmpty);
    style ??= OkDateTimePickerStyle.light;
  }

  /// Use displayItems to Control which items to display
  final List<DateTimeItem> displayItems;

  /// Using allowNullItems to Control which items can be select null value
  final List<DateTimeItem>? allowNullItems;
  final DateTime? initialTime;
  final DateTime? minTime;
  final DateTime? maxTime;
  final bool use24hFormat;
  final bool useLunarCalendar;
  late OkDateTimePickerStyle? style;
  final OkDateTimePickerValueCallback? onChanged;
  final OkDateTimePickerValueCallback? onConfirmed;
  final OkDateTimePickerCancelCallback? onCanceled;

  @override
  _OkDateTimePickerWidgetState createState() => _OkDateTimePickerWidgetState();
}

class _OkDateTimePickerWidgetState extends State<OkDateTimePickerWidget> {
  DateTimeEntity selectedDateTime = DateTimeEntity();

  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController secondController;
  late FixedExtentScrollController amPmController;

  @override
  void initState() {
    super.initState();

    if (widget.initialTime != null) {
      // selectedDateTime = DateTimeEntity.fromDateTime(widget.initialTime!);
    }
  }

  @override
  void dispose() {
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    amPmController.dispose();
    super.dispose();
  }

  void _onDateTimeChanged(DateTimeItem item, int index) {
    switch (item) {
      case DateTimeItem.year:
        int itemValue = _getYearRange()[index]['itemValue'];
        selectedDateTime.year = itemValue == -1 ? null : itemValue;
        break;
      case DateTimeItem.month:
        int itemValue = _getMonthRange()[index]['itemValue'];
        selectedDateTime.month = itemValue == -1 ? null : itemValue;
        break;
      case DateTimeItem.day:
        int itemValue = _getDayRange()[index]['itemValue'];
        selectedDateTime.day = itemValue == -1 ? null : itemValue;
        break;
      case DateTimeItem.hour:
        // TODO: Handle this case.
        break;
      case DateTimeItem.minute:
        // TODO: Handle this case.
        break;
      case DateTimeItem.second:
        // TODO: Handle this case.
        break;
    }
    if (selectedDateTime.day != null && selectedDateTime.day! > 28) {
      if (widget.useLunarCalendar) {
      } else {
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

  void _adjustToValidValue(int index) {
    // 自动调整为合法的值
  }

  List<Map> _getYearRange() {
    int startYear = widget.minTime?.year ?? 1900;
    int endYear = widget.maxTime?.year ?? 2100;
    List<Map> years = [];

    for (int i = startYear; i <= endYear; i++) {
      String itemTitle = '$i年';
      if (widget.useLunarCalendar) {
        itemTitle = getLunarYearName(i);
      }
      years.add({
        'itemValue': i,
        'itemTitle': itemTitle,
      });
    }

    if (widget.allowNullItems?.contains(DateTimeItem.year) ?? false) {
      years.add({'itemValue': -1, 'itemTitle': '----'});
    }
    return years;
  }

  List<Map> _getMonthRange() {
    List<Map> months = [];

    for (int i = 1; i <= 12; i++) {
      String itemTitle = '$i月';
      if (widget.useLunarCalendar) {
        itemTitle = '${getLunarMonthName(i)}月';
      }
      months.add({
        'itemValue': i,
        'itemTitle': itemTitle,
      });
    }

    if (widget.allowNullItems?.contains(DateTimeItem.month) ?? false) {
      months.add({'itemValue': -1, 'itemTitle': '--'});
    }

    return months;
  }

  List<Map> _getDayRange() {
    List<Map> days = [];

    int maxDay = widget.useLunarCalendar ? 30 : 31;

    for (int i = 1; i <= maxDay; i++) {
      String itemTitle = '$i日';
      if (widget.useLunarCalendar) {
        itemTitle = getLunarDayName(i);
      }
      days.add({
        'itemValue': i,
        'itemTitle': itemTitle,
      });
    }

    if (widget.allowNullItems?.contains(DateTimeItem.day) ?? false) {
      days.add({'itemValue': -1, 'itemTitle': '--'});
    }

    return days;
  }

  List<Map> _getHourRange() {
    List<Map> hours = [];
    int totalHour = widget.use24hFormat ? 24 : 12;
    for (int i = 0; i < totalHour; i++) {
      String itemValue = '${fillPrefixZero(i)}时';
      hours.add({
        'itemValue': i,
        'itemTitle': itemValue,
      });
    }

    if (widget.allowNullItems?.contains(DateTimeItem.hour) ?? false) {
      hours.add({'itemValue': -1, 'itemTitle': '--'});
    }
    return hours;
  }

  List<Map> _getMinuteRange() {
    List<Map> minutes = [];
    for (int i = 0; i < 60; i++) {
      String itemValue = '${fillPrefixZero(i)}分';
      minutes.add({
        'itemValue': i,
        'itemTitle': itemValue,
      });
    }

    if (widget.allowNullItems?.contains(DateTimeItem.minute) ?? false) {
      minutes.add({'itemValue': -1, 'itemTitle': '--'});
    }
    return minutes;
  }

  List<Map> _getSecondRange() {
    List<Map> seconds = [];
    for (int i = 0; i < 60; i++) {
      String itemValue = '${fillPrefixZero(i)}分';
      seconds.add({
        'itemValue': i,
        'itemTitle': itemValue,
      });
    }

    if (widget.allowNullItems?.contains(DateTimeItem.second) ?? false) {
      seconds.add({'itemValue': -1, 'itemTitle': '--'});
    }
    return seconds;
  }

  Widget _buildTimeColumn(DateTimeItem item) {
    List<Map> items;
    FixedExtentScrollController controller;
    DateTime initialDt = widget.initialTime ?? DateTime.now();

    switch (item) {
      case DateTimeItem.year:
        items = _getYearRange();
        int initialIdx = items.indexWhere((ele) => ele['itemValue'] == initialDt.year);
        yearController = FixedExtentScrollController(initialItem: initialIdx < 0 ? items.length - 1 : initialIdx);
        controller = yearController;
        break;
      case DateTimeItem.month:
        items = _getMonthRange();
        int initialIdx = items.indexWhere((ele) => ele['itemValue'] == initialDt.month);
        monthController = FixedExtentScrollController(initialItem: max(0, initialIdx));
        controller = monthController;
        break;
      case DateTimeItem.day:
        items = _getDayRange();
        int initialIdx = items.indexWhere((ele) => ele['itemValue'] == initialDt.day);
        dayController = FixedExtentScrollController(initialItem: max(0, initialIdx));
        controller = dayController;
        break;
      case DateTimeItem.hour:
        items = _getHourRange();
        int initialIdx = items.indexWhere((ele) => ele['itemValue'] == initialDt.hour);
        hourController = FixedExtentScrollController(initialItem: max(0, initialIdx));
        controller = hourController;
        break;
      case DateTimeItem.minute:
        items = _getMinuteRange();
        int initialIdx = items.indexWhere((ele) => ele['itemValue'] == initialDt.minute);
        minuteController = FixedExtentScrollController(initialItem: max(0, initialIdx));
        controller = minuteController;
        break;
      case DateTimeItem.second:
        items = _getSecondRange();
        int initialIdx = items.indexWhere((ele) => ele['itemValue'] == initialDt.second);
        secondController = FixedExtentScrollController(initialItem: max(0, initialIdx));
        controller = secondController;
        break;
      default:
        items = [];
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
              item['itemTitle'],
              style: widget.style?.selectedTextStyle,
            ),
          );
          // final isSelected = item['itemValue'] == selectedDateTime.
          // return Center(
          //   child: Text(
          //     item == -1 ? '---' : item.toString(),
          //     style: isSelected ? widget.style?.selectedTextStyle : widget.style?.unselectedTextStyle,
          //   ),
          // );
        }).toList(),
        onSelectedItemChanged: (int index) {
          print('onSelectedItemChanged $item $index');
          _onDateTimeChanged(item, index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.style!.pickerHeight + 80,
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
                child: Text('Cancel', style: widget.style?.cancelButtonTextStyle),
              ),
              TextButton(
                onPressed: () {
                  widget.onConfirmed?.call(_getSelectedDateTime());
                },
                child: Text('Confirm', style: widget.style?.confirmButtonTextStyle),
              ),
            ],
          ),
          SizedBox(
            height: widget.style?.pickerHeight,
            child: Row(
              children: widget.displayItems.map((item) => _buildTimeColumn(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
