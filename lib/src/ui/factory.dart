import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:ohmnyomer/src/constants.dart';

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

class BorderedCircleAvatar extends StatelessWidget {
  const BorderedCircleAvatar(String url, double size, {Key? key})
      : _url = url,
        _size = size,
        super(key: key);

  final double _size;
  final String _url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: _size,
        backgroundColor: Colors.black26,
        child: Builder(
          builder: (BuildContext context) {
            if (_url != "") {
              return CircleAvatar(
                radius: _size-1.0,
                foregroundImage: NetworkImage(_url),
                backgroundColor: Colors.white,
              );
            }
            return CircleAvatar(
              radius: _size-1.0,
              child: const Icon(Icons.person, color: Colors.black54),
              backgroundColor: Colors.white,
            );
          },
        )
    );
  }
}

class ListCard extends StatelessWidget {
  const ListCard(Widget leading, String content, String subContent,
      {Key? key, Widget? trailing})
      : _leading = leading,
        _trailing = trailing,
        _content = content,
        _subContent = subContent,
        super(key: key);

  final Widget _leading;
  final Widget? _trailing;
  final String _content;
  final String _subContent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          width: 60,
          child: Center(
            child: _leading,
          )
        ),
        title: Text(_content),
        subtitle: Text(_subContent),
        trailing: _trailing != null ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _trailing!,
          ],
        ) : null,
      ),
    );
  }
}
