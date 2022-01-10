import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ohmnyom/src/blocs/feed_bloc_provider.dart';
import 'package:ohmnyom/src/ui/feed_route.dart';

void main() => runApp(const AppMain());

class AppMain extends StatelessWidget {
  const AppMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
       statusBarColor: Colors.transparent,
       systemNavigationBarColor: Colors.transparent,
    ));

    return MaterialApp(
      title: '옴뇸뇸뇸',
      theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  primary: Colors.yellow,
                  onPrimary: Colors.black,
                  minimumSize: const Size(124, 60),
                  fixedSize: const Size(124, 60),
                  elevation: 6,
                  alignment: Alignment.center
              )
          )
      ),
        home: FeedBlocProvider(
          child: FeedRoute(),
        )
    );
  }
}
