import 'package:dartnyom/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc_provider.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc_provider.dart';
import 'package:ohmnyomer/src/ui/error_dialog.dart';
import 'package:ohmnyomer/src/ui/signin_route.dart';

class FeedRoute extends StatefulWidget {
  const FeedRoute({Key? key}) : super(key: key);

  @override
  _FeedRouteState createState() => _FeedRouteState();
}

class _FeedRouteState extends State<FeedRoute> {
  late FeedBloc bloc;
  // Account? _account;

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
                        return const CircleAvatar(
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
                      const SnackBar(content: Text('Signing Out')),
                    ),
                    bloc.signOut(),
                  },
                  child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black26,
                      child: Builder(
                        builder: (BuildContext context) {
                          if (account.photourl != "") {
                            return CircleAvatar(
                              radius: 19,
                              foregroundImage: NetworkImage(account.photourl),
                              backgroundColor: Colors.white,
                            );
                          }
                          return const CircleAvatar(
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

  Widget _feedList() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.separated(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return const ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              foregroundImage: AssetImage('assets/feed/bowl-full.jpeg'),
            ),
            title: Text('오전 07:23'),
            trailing: Text('1/4 컵'),
            // tileColor: Colors.lightGreenAccent,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

  Widget _feedRoute(Account account) {
    return Scaffold(
        body: Column(
          children: [
            _topPanel(account),
            Expanded(child: _feedList()),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton.icon(
            onPressed: () {  },
            icon: const Icon(Icons.add),
            label: const Text('밥 먹자', style: TextStyle(
              fontSize: 20,
            ),),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.accountSubject,
      builder: (context, AsyncSnapshot<Account?> snapshot) {
        if (snapshot.hasData) {
          Account account = snapshot.data!;
          return _feedRoute(account);
        } else if (snapshot.hasError) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            ErrorDialog().show(context, snapshot.error!);
          });
        }
        return SignBlocProvider(child: const SignInRoute());
      },
    );
  }
}
