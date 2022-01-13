class Feed {
  Feed({
    required this.feeded,
    required this.feeder,
    required this.amount,
    required this.unit,
  });

  DateTime feeded;
  String feeder;
  double amount;
  String unit;
}