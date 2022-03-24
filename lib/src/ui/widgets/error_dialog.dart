import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

class ErrorDialog {
  static final ErrorDialog _singleton =
  ErrorDialog._internal();
  bool _isShowing = false;

  factory ErrorDialog() {
    return _singleton;
  }

  ErrorDialog._internal();

  show(BuildContext context, Object e) {
    if (!_isShowing) {
      _isShowing = true;
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(_title(e)),
            content: Text(_content(e)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ).then((value) => _isShowing = false);
    }
  }

  showInputAssert(BuildContext context, String title, String content) {
    if (!_isShowing) {
      _isShowing = true;
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ).then((value) => _isShowing = false);
    }
  }

  String _title(Object e) {
    if (e is GrpcError) {
      return e.codeName;
    }
    return e.runtimeType.toString();
  }

  String _content(Object e) {
    if (e is GrpcError) {
      return e.message!;
    }
    return e.toString();
  }
}
