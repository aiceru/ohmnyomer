import 'package:flutter/material.dart';

Widget hintText(String content) {
  return Text(
    content,
    style: kHintTextStyle,
  );
}

const kHintTextStyle = TextStyle(
  color: Colors.black38,
);

Widget smallLabel(String content) {
  return Text(
    content,
    style: kSmallLabelStyle,
  );
}

const kSmallLabelStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    height: 1.6,
    textBaseline: TextBaseline.ideographic,
    shadows: [
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

Widget label(String content) {
  return Text(
    content,
    style: kLabelStyle,
  );
}

const kLabelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 26,
    height: 1.6,
    textBaseline: TextBaseline.ideographic,
    shadows: [
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
    style: kInfoTitleTextStyle,
  );
}

const kInfoTitleTextStyle = TextStyle(
  color: Colors.black54,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  // height: 1.8,
  textBaseline: TextBaseline.ideographic,
);

Text infoText(String content) {
  return Text(
    content,
    style: kInfoTextStyle,
  );
}

const kInfoTextStyle = TextStyle(
  color: Colors.black54,
  fontSize: 16.0,
  // height: 2.0,
  textBaseline: TextBaseline.ideographic,
);
