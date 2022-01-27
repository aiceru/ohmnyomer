import 'package:flutter/material.dart';

Text hintText(String content) {
  return Text(
    content,
    style: kHintTextStyle,
  );
}

const kHintTextStyle = TextStyle(
  color: Colors.black38,
);

Text smallLabel(String content) {
  return Text(
    content,
    style: kSmallLabelStyle,
  );
}

const kSmallLabelStyle = TextStyle(
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

Text label(String content) {
  return Text(
    content,
    style: kLabelStyle,
  );
}

const kLabelStyle = TextStyle(
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

Widget buildTextField(
    IconData? icon, String? hintText,
    String? Function (String?) validator, TextEditingController controller,
    {bool? obsecureText}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
    alignment: Alignment.centerLeft,
    decoration: kBoxDecorationStyle,
    height: 60.0,
    child: TextFormField(
      validator: (value) => validator(value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obsecureText ?? false,
      style: const TextStyle(
        color: Colors.black54,
      ),
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          icon,
          color: Colors.black38,
        ),
        hintText: hintText,
        hintStyle: kHintTextStyle,
      ),
    ),
  );
}

Widget socialLogo(ImageProvider img) {
  return Container(
    height: 60.0,
    width: 60.0,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
        image: DecorationImage(
          image: img,
          fit: BoxFit.scaleDown,
        )
    ),
  );
}