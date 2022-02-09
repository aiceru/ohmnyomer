import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/constants.dart';

Widget buildTextField(
    IconData? icon, String? hintText, TextInputType? keyboardType,
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
      keyboardType: keyboardType,
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

Widget socialLogo(String provider, double size) {
  ImageProvider img;
  switch (provider) {
    case oauthProviderGoogle:
      img = const Svg(ciPathGoogle);
      break;
    case oauthProviderKakao:
      img = const Svg(ciPathKakao);
      break;
    default:
      return const SizedBox.shrink();
  }
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.2, 0.2),
            blurRadius: 1.0,
          ),
        ],
        image: DecorationImage(
          image: img,
          fit: BoxFit.scaleDown,
        )
    ),
  );
}
