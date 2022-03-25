import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

class ErrorDialog {
  static final ErrorDialog _singleton = ErrorDialog._internal();

  factory ErrorDialog() {
    return _singleton;
  }

  ErrorDialog._internal();

  Future? show(BuildContext context, Object e) {
    return showDialog<void>(
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
    );
  }

  showInputAssert(BuildContext context, String title, String content) {
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
        }
    );
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
