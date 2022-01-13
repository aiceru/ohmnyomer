import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc.dart';

class FeedBlocProvider extends InheritedWidget {
  final FeedBloc bloc;

  FeedBlocProvider({Key? key, required Widget child})
  : bloc = FeedBloc(),
  super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static FeedBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FeedBlocProvider>()!.bloc;
  }
}