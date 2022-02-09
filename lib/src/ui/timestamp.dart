import 'package:intl/intl.dart';

DateTime dateTimeFromEpochSeconds(int seconds) {
  return DateTime.fromMillisecondsSinceEpoch(
      seconds * Duration.millisecondsPerSecond, isUtc: true).toLocal();
}

extension Timestamp on DateTime {
  int toSecondsSinceEpoch() {
    return toUtc().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
  }

  String formatDate() {
    return DateFormat('yyyy. M. d').format(this);
  }

  String formatDateTime() {
    return DateFormat('yyyy. M. d / K:mm a').format(this);
  }
}