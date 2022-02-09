import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/ui/routes/signin_route.dart';

class SplashRoute extends StatefulWidget {
  const SplashRoute({Key? key}) : super(key: key);
  static const routeName = '/SplashScreen';

  @override
  _SplashRouteState createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<List<bool>>(
        future: Future.wait([
          Repository().initSharedPreference(),
          Repository().initConfigData(context),
        ]),
        builder: (context, AsyncSnapshot<List<bool>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data![0] == true && snapshot.data![1] == true) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(SignInRoute.routeName);
              });
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}