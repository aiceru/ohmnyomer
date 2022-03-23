import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/resources/ad/ad_helper.dart';
import 'package:ohmnyomer/src/resources/invite/inviter.dart';
import 'package:ohmnyomer/src/resources/repository/repository.dart';
import 'package:ohmnyomer/src/ui/routes/feed_route.dart';
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
      body: FutureBuilder<List<void>>(
        future: Future.wait([
          Repository().initSharedPreference(),
          Repository().initConfigData(context),
          AdHelper().initialize(),
          Inviter().initialize(),
        ]),
        builder: (context, AsyncSnapshot<List<void>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            FirebaseDynamicLinks.instance.onLink.listen((event) {
              Repository().account == null
                  ? Navigator.of(context).pushNamed(SignInRoute.routeName)
                  : Navigator.of(context).pushNamed(FeedRoute.routeName);
            });
            FirebaseDynamicLinks.instance.getInitialLink()
            .then((value) {
              if (value != null) {
                Repository().invitedInfo = value.link.queryParameters;
              }
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(SignInRoute.routeName);

              });
            });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}