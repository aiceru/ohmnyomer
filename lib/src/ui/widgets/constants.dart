import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:sizer/sizer.dart';

// 1.w = 4.1
// 1.h = 8.9

Widget hintText(String content) {
  return Text(
    content,
    style: hintTextStyle(),
  );
}

TextStyle hintTextStyle() {
  return const TextStyle(color: Colors.black38);
}

Widget smallLabel(String content) {
  return Text(
    content,
    style: smallLabelTextStyle(),
  );
}

TextStyle smallLabelTextStyle() {
  return TextStyle(
      color: Colors.black,
      fontSize: 12.sp,
      height: 1.6,
      textBaseline: TextBaseline.ideographic,
      shadows: const [
        Shadow(
          blurRadius: 20.0,
          color: Colors.white,
          offset: Offset(0, 0),
        ),
        Shadow(
          blurRadius: 20.0,
          color: Colors.white,
          offset: Offset(0, 0),
        ),
        Shadow(
          blurRadius: 20.0,
          color: Colors.white,
          offset: Offset(0, 0),
        ),
      ]
  );
}

Widget label(String content) {
  return Text(
    content,
    style: labelTextStyle(),
  );
}

TextStyle labelTextStyle() {
  return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18.sp,
      height: 1.6,
      textBaseline: TextBaseline.ideographic,
      shadows: const [
        Shadow(
          blurRadius: 20.0,
          color: Colors.white,
          offset: Offset(0, 0),
        ),
        Shadow(
          blurRadius: 20.0,
          color: Colors.white,
          offset: Offset(0, 0),
        ),
        Shadow(
          blurRadius: 20.0,
          color: Colors.white,
          offset: Offset(0, 0),
        ),
      ]
  );
}

final kBoxDecorationStyle = BoxDecoration(
  color: const Color.fromRGBO(255, 255, 255, 0.7),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

Text infoTitleText(String content) {
  return Text(
    content,
    style: infoTitleTextStyle(),
  );
}

TextStyle infoTitleTextStyle() {
  return TextStyle(
    color: Colors.black54,
    fontSize: fontSizeMedium.sp,
    // fontWeight: FontWeight.bold,
    height: 1.8,
    textBaseline: TextBaseline.ideographic,
  );
}

Text infoText(String content) {
  return Text(
    content,
    style: infoTextStyle(),
  );
}

TextStyle infoTextStyle() {
  return TextStyle(
    color: Colors.black54,
    fontSize: fontSizeSmall.sp,
    height: 1.0,
    textBaseline: TextBaseline.ideographic,
  );
}

EdgeInsets routeTopPanelPadding() {
  return EdgeInsets.fromLTRB(6.w, 5.3.h, 6.w, 0);
}

EdgeInsets routeBodyPadding() {
  return EdgeInsets.all(1.w);
}
