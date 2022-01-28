import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/blocs/edit_account_bloc.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc.dart';

class EditAccountBlocProvider extends InheritedWidget {
  final EditAccountBloc bloc;

  EditAccountBlocProvider({Key? key, required Widget child})
  : bloc = EditAccountBloc(),
  super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static EditAccountBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EditAccountBlocProvider>()!.bloc;
  }
}