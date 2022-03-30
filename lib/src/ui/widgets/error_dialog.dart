import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

class AlertContents {
  String title;
  String content;
  AlertContents(this.title, this.content);
}

class ErrorDialog {
  static final ErrorDialog _singleton = ErrorDialog._internal();
  static bool _isShowing = false;

  factory ErrorDialog() {
    return _singleton;
  }

  ErrorDialog._internal();

  Future? _show(BuildContext context, AlertContents alert) {
    if (_isShowing) {
      return null;
    }
    _isShowing = true;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alert.title),
          content: Text(_content(alert.content)),
          actions: [
            TextButton(
              onPressed: () =>
              {
                _isShowing = false,
                Navigator.of(context).pop(),
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future? show(BuildContext context, Object e) {
    return _show(context, AlertContents(_title(e), _content(e)));
  }

  Future? showAlert(BuildContext context, String title, String content) {
    return _show(context, AlertContents(title, content));
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
