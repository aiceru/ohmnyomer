import 'package:flutter/material.dart';
import 'package:ohmnyom/src/blocs/feed_bloc.dart';
import 'package:ohmnyom/src/blocs/feed_bloc_provider.dart';
import 'package:ohmnyom/src/blocs/signin_bloc_provider.dart';
import 'package:ohmnyom/src/models/account.dart';
import 'package:ohmnyom/src/ui/signin_route.dart';
import 'feed_list.dart';

class FeedRoute extends StatefulWidget {
  const FeedRoute({Key? key}) : super(key: key);

  @override
  _FeedRouteState createState() => _FeedRouteState();
}

class _FeedRouteState extends State<FeedRoute> {
  late FeedBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = FeedBlocProvider.of(context);
    bloc.fetchAccount();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget _topPanel(Account account) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.black26,
                  child: Builder(
                      builder: (BuildContext context) {
                        return CircleAvatar(
                          radius: 21,
                          foregroundImage: AssetImage('assets/dev/iu1.jpeg'),
                          backgroundColor: Colors.white,
                        );
                      }
                  ),
                ),
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: const Text('춘식이',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )
                ),
                GestureDetector(
                  onTap: () => {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Signing Out')),
                    ),
                    bloc.signOut(),
                  },
                  child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black26,
                      child: Builder(
                        builder: (BuildContext context) {
                          if (account.photoUrl != null) {
                            return CircleAvatar(
                              radius: 19,
                              foregroundImage: NetworkImage(account.photoUrl!),
                              backgroundColor: Colors.white,
                            );
                          }
                          return CircleAvatar(
                            radius: 19,
                            child: Icon(Icons.person, color: Colors.black54),
                            backgroundColor: Colors.white,
                          );
                        },
                      )
                  )
                  ,
                ),
              ],
            ),
            height: MediaQuery
                .of(context)
                .size
                .height * 0.1,
          )
        ],
      ),
      // color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.accountSubject,
      builder: (context, AsyncSnapshot<Account?> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isSignedIn()) {
            return Scaffold(
                body: Column(
                  children: [
                    _topPanel(snapshot.data!),
                    Expanded(child: FeedList()),
                  ],
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    onPressed: () {  },
                    icon: Icon(Icons.add),
                    label: const Text('밥 먹자', style: TextStyle(
                      fontSize: 20,
                    ),),
                  ),
                )
            );
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
