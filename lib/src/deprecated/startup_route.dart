import 'package:flutter/material.dart';
import 'package:ohmnyom/src/blocs/signin_bloc_provider.dart';
import 'package:ohmnyom/src/deprecated/startup_bloc.dart';
import 'package:ohmnyom/src/deprecated/startup_bloc_provider.dart';
import 'package:ohmnyom/src/ui/feed_route.dart';
import 'package:ohmnyom/src/ui/signin_route.dart';

import '../models/account.dart';

class StartupRoute extends StatefulWidget {
  const StartupRoute({Key? key}) : super(key: key);

  @override
  _StartupRouteState createState() => _StartupRouteState();
}

class _StartupRouteState extends State<StartupRoute> {
  late StartupBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = StartupBlocProvider.of(context);
    bloc.fetchAccount();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.accountSubject,
      builder: (context, AsyncSnapshot<Account?> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isSignedIn()) {
            return FeedRoute();
          } else {
            return SignInBlocProvider(child: SignInRoute());
          }
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}