import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/constants.dart';
import 'package:sizer/sizer.dart';

Widget buildTextField(
    IconData? icon, String? hintText, TextInputType? keyboardType,
    String? Function (String?) validator, TextEditingController controller,
    {bool? obscureText}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 2.0.w),//, vertical: 1.0.h),
    alignment: Alignment.topLeft,
    height: 8.h,
    child: TextFormField(
      validator: (value) => validator(value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.black54,
      ),
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        // border: InputBorder.none,
        icon: Icon(
          icon,
          color: Colors.black38,
        ),
        hintText: hintText,
        hintStyle: hintTextStyle(),
      ),
    ),
  );
}

Widget buildSimpleTextField(String? hintText,
    TextInputType? keyboardType, TextEditingController controller) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.h),
    alignment: Alignment.centerLeft,
    decoration: kBoxDecorationStyle,
    height: 6.7.h,
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.black54,
      ),
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: hintTextStyle(),
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
