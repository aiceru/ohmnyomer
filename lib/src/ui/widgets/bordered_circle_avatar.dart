import 'package:flutter/material.dart';

class BorderedCircleAvatar extends StatelessWidget {
  const BorderedCircleAvatar(this.size, {Key? key, this.networkSrc, this.iconData})
      : assert(networkSrc != null || iconData != null),
        assert(networkSrc == null || iconData == null),
        super(key: key);

  final double size;
  final String? networkSrc;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: size,
        backgroundColor: Colors.black26,
        child: iconData != null ?
        CircleAvatar(
          radius: size - 1.0,
          child: Icon(iconData, color: Colors.black54),
          backgroundColor: Colors.white,
        ) :
        CircleAvatar(
          radius: size - 1.0,
          foregroundImage: NetworkImage(networkSrc!),
          backgroundColor: Colors.white,
        )
    );
  }
}
