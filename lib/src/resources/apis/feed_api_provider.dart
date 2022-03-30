import 'package:dartnyom/protonyom_api_feed.pbgrpc.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:ohmnyomer/src/resources/apis/api_provider.dart';
import 'package:ohmnyomer/src/resources/apis/auth_interceptor.dart';

class FeedApiProvider {
  final ApiProvider _apiProvider;

  FeedApiProvider()
  : _apiProvider = ApiProvider();

  FeedApiClient _newClientWithAuth(String authToken) {
    return FeedApiClient(
      _apiProvider.channel,
      options: _apiProvider.callOptions,
      interceptors: [AuthInterceptor(authToken)],
    );
  }

  Future<Feed> addFeeds(String authToken, Feed feed) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.addFeed(
      AddFeedRequest()
          ..feed = feed
    );
    return resp.feed;
  }

  Future<List<Feed>> getFeeds(String authToken, String petId,
      int startAfter, int limit) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.getFeeds(
        GetFeedsRequest()
          ..petId = petId
          ..startAfter = Int64(startAfter)
          ..limit = limit
    );
    return resp.feeds;
  }

  Future deleteFeed(String authToken, String petId, String feedId) {
    final client = _newClientWithAuth(authToken);
    return client.deleteFeed(
      DeleteFeedRequest()
          ..petId = petId
          ..feedId = feedId
    );
  }

  Future<Feed> updateFeed(String authToken, Feed feed) async {
    final client = _newClientWithAuth(authToken);
    final resp = await client.updateFeed(
      UpdateFeedRequest()
          ..feed = feed
    );
    return resp.feed;
  }
}