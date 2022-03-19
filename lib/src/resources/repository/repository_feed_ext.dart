import 'dart:typed_data';

import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:ohmnyomer/src/resources/apis/pet_api_provider.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';

extension RepositoryFeedExt on Repository {
  Future<Feed> addFeed(Feed feed) async {
    return feedApiProvider.addFeeds(authToken!, feed);
  }

  Future<List<Feed>> getFeeds(String petId, int startAfter, int limit) async {
    return feedApiProvider.getFeeds(authToken!, petId, startAfter, limit);
  }

  Future deleteFeed(String petId, String feedId) {
    return feedApiProvider.deleteFeed(authToken!, petId, feedId);
  }

  Future<Feed> updateFeed(Feed feed) async {
    return feedApiProvider.updateFeed(authToken!, feed);
  }
}