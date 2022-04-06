import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/secrets.dart';

class AuthInterceptor implements ClientInterceptor {
  AuthInterceptor();

  AuthInterceptor.withToken(String authToken)
  : _authToken = authToken;

  String? _authToken;

  @override
  ResponseStream<R> interceptStreaming<Q, R>(ClientMethod<Q, R> method, Stream<Q> requests, CallOptions options, ClientStreamingInvoker<Q, R> invoker) {
    var meta = <String, String>{};
    if (_authToken != null) {
      meta[userAuthHeaderKey] = _authToken!;
    }
    if (kReleaseMode) {
      meta['x-api-key'] = ohmnyomApiKey;
    }
    var _options = options.mergedWith(CallOptions(metadata: meta));
    return invoker(method, requests, _options);
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request, CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
    var meta = <String, String>{};
    if (_authToken != null) {
      meta[userAuthHeaderKey] = _authToken!;
    }
    if (kReleaseMode) {
      meta['x-api-key'] = ohmnyomApiKey;
    }
    var _options = options.mergedWith(CallOptions(metadata: meta));
    return invoker(method, request, _options);
  }
}