import 'package:dartnyom/protonyom_api_feed.pbgrpc.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/apis/auth_interceptor.dart';
import 'package:ohmnyomer/src/secrets.dart';

class FeedApiProvider {
  final ClientChannel channel;
  final CallOptions _callOptions = CallOptions(
    metadata: {'x-api-key': ohmnyomApiKey},
    compression: const GzipCodec(),
    timeout: const Duration(seconds: 5),
  );

  FeedApiProvider()
      : channel = ClientChannel(
    ohmnyomServerHost,
    port: ohmnyomServerPort,
    options: ChannelOptions(
      codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      connectionTimeout: const Duration(seconds: 5),
    ),
  );

  FeedApiClient _newClientWithAuth(String authToken) {
    return FeedApiClient(
      channel,
      options: _callOptions,
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