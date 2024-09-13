import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ok_datetime_picker_style.dart';
import 'model/datetime_entity.dart';

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
    bool use24hFormat = true,
    OkDateTimePickerStyle? style,
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
          use24hFormat: use24hFormat,
          style: style ?? OkDateTimePickerStyle.light,
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
    bool use24hFormat = true,
    OkDateTimePickerStyle? style,
  }) {
    return OkDateTimePickerWidget(
      displayItems: displayItems,
      allowNullItems: allowNullItems,
      initialTime: initialTime,
      minTime: minTime,
      maxTime: maxTime,
      use24hFormat: use24hFormat,
      style: style ?? OkDateTimePickerStyle.light,
    );
  }
}

///
/// OkDateTimePickerWidget
///
class OkDateTimePickerWidget extends StatefulWidget {

  OkDateTimePickerWidget({
    super.key,
    required this.displayItems,
    this.allowNullItems,
    this.initialTime,
    this.minTime,
    this.maxTime,
    this.use24hFormat = true,
    this.useLunarCalendar = false,
    this.style = OkDateTimePickerStyle.light,
    this.onChanged,
    this.onConfirmed,
    this.onCanceled,
  }) : assert(displayItems.isNotEmpty);

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
  _OkDateTimePickerWidgetState createState() => _OkDateTimePickerWidgetState();
}

class _OkDateTimePickerWidgetState extends State<OkDateTimePickerWidget> {
  List<int?> selectedValues = List<int?>.filled(6, null); // year, month, day, hour, minute, second

  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController secondController;

  @override
  void initState() {
    super.initState();

    yearController = FixedExtentScrollController();
    monthController = FixedExtentScrollController();
    dayController = FixedExtentScrollController();
    hourController = FixedExtentScrollController();
    minuteController = FixedExtentScrollController();
    secondController = FixedExtentScrollController();

    if (widget.initialTime != null) {
      DateTime initialTime = widget.initialTime!;
      selectedValues[0] = initialTime.year;
      selectedValues[1] = initialTime.month;
      selectedValues[2] = initialTime.day;
      selectedValues[3] = initialTime.hour;
      selectedValues[4] = initialTime.minute;
      selectedValues[5] = initialTime.second;
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
    super.dispose();
  }

  Widget _buildTimeColumn(DateTimeItem type) {
    List<int> items;
    FixedExtentScrollController controller;
    int index;

    switch (type) {
      case DateTimeItem.year:
        items = _getYearRange();
        controller = yearController;
        index = 0;
        break;
      case DateTimeItem.month:
        items = _getMonthRange();
        controller = monthController;
        index = 1;
        break;
      case DateTimeItem.day:
        items = _getDayRange();
        controller = dayController;
        index = 2;
        break;
      case DateTimeItem.hour:
        items = _getHourRange();
        controller = hourController;
        index = 3;
        break;
      case DateTimeItem.minute:
        items = _getMinuteRange();
        controller = minuteController;
        index = 4;
        break;
      case DateTimeItem.second:
        items = _getSecondRange();
        controller = secondController;
        index = 5;
        break;
      default:
        items = [];
        controller = FixedExtentScrollController();
        index = 0;
    }

    if (widget.allowNullItems?.contains(DateTimeItem.values[index]) ?? false) {
      items.insert(0, -1); // '---' 的表示为 -1
    }

    return Expanded(
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: 32.0,
        onSelectedItemChanged: (int value) {
          if (items[value] == -1) {
            selectedValues[index] = null; // 选择空值
          } else {
            onTimeSelected(index, items[value]);
          }
        },
        children: items.map((item) {
          final isSelected = (items[value] == item);
          return Center(
            child: Text(
              item == -1 ? '---' : item.toString(),
              style: isSelected ? widget.style.selectedTextStyle : widget.style.unselectedTextStyle,
            ),
          );
        }).toList(),
      ),
    );
  }

  void onTimeSelected(int index, int value) {
    selectedValues[index] = value;
    DateTime selectedTime = _getSelectedDateTime();

    if (!isValidSelection(selectedTime)) {
      _adjustToValidValue(index);
    } else {
      setState(() {});
    }
  }

  DateTimeEntity _getSelectedDateTime() {
    return DateTimeEntity(
      year: selectedValues[0],
      month: selectedValues[1],
      day: selectedValues[2],
      hour: selectedValues[3],
      minute: selectedValues[4],
      second: selectedValues[5],
    );
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

  List<int> _getYearRange() {
    int startYear = widget.minTime?.year ?? 1900;
    int endYear = widget.maxTime?.year ?? 2100;
    return List.generate(endYear - startYear + 1, (index) => startYear + index);
  }

  List<int> _getMonthRange() {
    return List.generate(12, (index) => index + 1);
  }

  List<int> _getDayRange() {
    return List.generate(31, (index) => index + 1);
  }

  List<int> _getHourRange() {
    return List.generate(widget.use24hFormat ? 24 : 12, (index) => index + 1);
  }

  List<int> _getMinuteRange() {
    return List.generate(60, (index) => index);
  }

  List<int> _getSecondRange() {
    return List.generate(60, (index) => index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if (widget.onCanceled != null) widget.onCanceled!();
              },
              child: Text('Cancel', style: widget.style.cancelButtonTextStyle),
            ),
            TextButton(
              onPressed: () {
                if (widget.onConfirmed != null) widget.onConfirmed!(_getSelectedDateTime());
              },
              child: Text('Confirm', style: widget.style.confirmButtonTextStyle),
            ),
          ],
        ),
        SizedBox(
          height: 250,
          child: Row(
            children: widget.displayItems.map((item) => _buildTimeColumn(item)).toList(),
          ),
        ),
      ],
    );
  }
}
