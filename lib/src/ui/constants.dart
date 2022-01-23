import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.black38,
);

final kSmallLabelStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
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

final kLabelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 26,
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
  color: Color.fromRGBO(255, 255, 255, 0.7),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

// buildLoading(BuildContext context) {
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       });
// }