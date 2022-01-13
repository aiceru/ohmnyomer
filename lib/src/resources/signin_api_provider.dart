import 'package:dartnyom/sign_api.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class SignInApiProvider {
  SignInApiProvider();

  signIn() async {
    final channel = ClientChannel(
      '192.168.0.10',
      port: 50051,
      options: ChannelOptions(
        credentials: ChannelCredentials.insecure(),
        codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );
    
    final stub = SignApiClient(channel);
    try {
      final resp = await stub.signIn(
        SignInRequest()
            ..id = 'dart-test-id'
            ..password = 'dart-passwd'
            ..oauthid = 'dart-oauth-id'
            ..oauthtype = OAuthType.GOOGLE,
        options: CallOptions(compression: const GzipCodec()),
      );
      print('response: $resp');
    } catch (e) {
      print('Caught error: $e');
    }
    await channel.shutdown();
  }
}