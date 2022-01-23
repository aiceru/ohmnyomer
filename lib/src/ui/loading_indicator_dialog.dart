import 'package:flutter/material.dart';

class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _singleton =
      LoadingIndicatorDialog._internal();

  BuildContext? _context;
  bool _isShowing = false;

  factory LoadingIndicatorDialog() {
    return _singleton;
  }

  LoadingIndicatorDialog._internal();

  show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _context = context;
        _isShowing = true;
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(child: CircularProgressIndicator())
        );
      },
    );
  }

  dismiss() {
    if (_context != null && _isShowing) {
      Navigator.of(_context!).pop();
    }
  }
}