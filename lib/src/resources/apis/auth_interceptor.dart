import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/src/constants.dart';

class AuthInterceptor implements ClientInterceptor {
  AuthInterceptor(String authToken)
  : _authToken = authToken;

  final String _authToken;

  @override
  ResponseStream<R> interceptStreaming<Q, R>(ClientMethod<Q, R> method, Stream<Q> requests, CallOptions options, ClientStreamingInvoker<Q, R> invoker) {
    var _options = options.mergedWith(
        CallOptions(
            metadata: <String, String>{
              grpcAuthHeaderKey: _authToken
            }
        )
    );
    return invoker(method, requests, _options);
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request, CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
    var _options = options.mergedWith(
      CallOptions(
        metadata: <String, String>{
          grpcAuthHeaderKey: _authToken
        }
      )
    );
    return invoker(method, request, _options);
  }
}