import 'package:flutter/material.dart';

class OkDateTimePickerStyle {
  OkDateTimePickerStyle({
    this.cancelButtonTextStyle,
    this.confirmButtonTextStyle,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.backgroundColor,
    this.height = 250,
  });

  /// The style for cancel button's [Text] widget.
  final TextStyle? cancelButtonTextStyle;

  /// The style for confirm button's [Text] widget.
  final TextStyle? confirmButtonTextStyle;

  /// The style for picker selected text widget.
  final TextStyle? selectedTextStyle;

  /// The style for picker unselected text widget.
  final TextStyle? unselectedTextStyle;

  /// The picker widget background color.
  final Color? backgroundColor;

  final double height;

  static OkDateTimePickerStyle light = OkDateTimePickerStyle(
    cancelButtonTextStyle: TextStyle(color: Colors.blue, fontSize: 16),
    confirmButtonTextStyle: TextStyle(color: Colors.blue, fontSize: 16),
    selectedTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
    unselectedTextStyle: TextStyle(color: Colors.grey, fontSize: 16),
    backgroundColor: Colors.white,
    height: 250,
  );

  static OkDateTimePickerStyle dark = OkDateTimePickerStyle(
    cancelButtonTextStyle: TextStyle(color: Colors.white, fontSize: 16),
    confirmButtonTextStyle: TextStyle(color: Colors.white, fontSize: 16),
    selectedTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    unselectedTextStyle: TextStyle(color: Colors.grey, fontSize: 16),
    backgroundColor: Colors.black,
    height: 250,
  );

  OkDateTimePickerStyle copyWith({
    TextStyle? cancelButtonTextStyle,
    TextStyle? confirmButtonTextStyle,
    TextStyle? selectedTextStyle,
    TextStyle? unselectedTextStyle,
    Color? backgroundColor,
    double? height,
  }) {
    return OkDateTimePickerStyle(
      cancelButtonTextStyle: cancelButtonTextStyle ?? this.cancelButtonTextStyle,
      confirmButtonTextStyle: confirmButtonTextStyle ?? this.confirmButtonTextStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      unselectedTextStyle: unselectedTextStyle ?? this.unselectedTextStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      height: height ?? this.height,
    );
  }
}
