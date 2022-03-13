import 'dart:io';
import 'package:flutter/material.dart';

class BorderedCircleAvatar extends StatelessWidget {
  const BorderedCircleAvatar(this.size, {Key? key, this.file, this.networkSrc, this.iconData})
      : assert(file != null || networkSrc != null || iconData != null),
        super(key: key);

  final double size;
  final File? file;
  final String? networkSrc;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: size,
        backgroundColor: Colors.black26,
        child: file != null ?
        CircleAvatar(
          radius: size-1.0,
          foregroundImage: FileImage(file!),
          backgroundColor: Colors.white,
        ) : networkSrc != null && networkSrc!.isNotEmpty ?
        CircleAvatar(
          radius: size - 1.0,
          foregroundImage: NetworkImage(networkSrc!),
          backgroundColor: Colors.white,
        ) :
        CircleAvatar(
          radius: size - 1.0,
          child: Icon(iconData, color: Colors.black54),
          backgroundColor: Colors.white,
        )
    );
  }
}
