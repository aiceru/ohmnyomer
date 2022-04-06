import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';

class ApiProvider {
  static final ApiProvider _apiProvider = ApiProvider._createInstance();

  factory ApiProvider() {
    return _apiProvider;
  }

  final ClientChannel channel;
  final CallOptions callOptions = CallOptions(
    compression: const GzipCodec(),
    timeout: const Duration(seconds: kReleaseMode ? 10 : 10000),
  );

  ApiProvider._createInstance()
      : channel = ClientChannel(
    kReleaseMode ? ohmnyomServerHost : ohmnyomServerHostDebug,
    port: kReleaseMode ? ohmnyomServerPort : ohmnyomServerPortDebug,
    options: ChannelOptions(
      credentials: kReleaseMode
          ? const ChannelCredentials.secure()
          : const ChannelCredentials.insecure(),
      codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      connectionTimeout: const Duration(seconds: kReleaseMode ? 10 : 10000),
    ),
  );
}