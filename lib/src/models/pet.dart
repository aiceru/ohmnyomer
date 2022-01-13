import 'package:ohmnyomer/src/models/feed.dart';
import '';

class Pet {
  Pet({
    required this.id,
    required this.name,
    this.adopted,
    this.kind,
    // this.feeds = <Feed>[],
  });

  String id;
  String name;
  DateTime? adopted;
  String? kind;
  // List<Feed> feeds;
}