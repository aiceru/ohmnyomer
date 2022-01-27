import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc_provider.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/ui/factory.dart';
import 'package:ohmnyomer/src/ui/error_dialog.dart';
import 'package:ohmnyomer/src/ui/signin_route.dart';

class FeedRoute extends StatefulWidget {
  const FeedRoute({Key? key}) : super(key: key);
  static const routeName = '/feedRoute';

  @override
  _FeedRouteState createState() => _FeedRouteState();
}

class _FeedRouteState extends State<FeedRoute> {
  late FeedBloc _bloc;
  // Account? _account;
  late Widget _userAvatar;
  late Widget _petAvatar;

  @override
  void didChangeDependencies() {
    _bloc = FeedBlocProvider.of(context);
    _bloc.fetchAccount();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget _buildTitleRow(Account account) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _userAvatar,
        const SizedBox(width: 20),
        Text(account.email, style: const TextStyle(fontSize: 16.0)),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildNameRow(Account account) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 40,
      child: Row(
        children: [
          const Icon(Icons.face, color: Colors.grey),
          const SizedBox(width: 35),
          Text(account.name),
        ],
      ),
    );
  }

  Widget _buildOAuthLinkAvatar(OAuthInfo_Provider provider) {
    switch (provider) {
      case OAuthInfo_Provider.GOOGLE:
        return const Image(image: Svg(ciPathGoogle));
      case OAuthInfo_Provider.KAKAO:
        return const Image(image: Svg(ciPathKakao));
    }
    return const SizedBox.shrink();
  }

  Widget _buildOAuthLinkRow(Account account) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 40,
      child: Row(
        children: [
          const Icon(Icons.link, color: Colors.grey),
          const SizedBox(width: 20),
          for (var info in account.oauthinfo)
            _buildOAuthLinkAvatar(info.provider),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return GestureDetector(
      onTap:() {
        Navigator.of(context).pop();    // dismiss dialog
        _bloc.signOut();
        Navigator.of(context).pushReplacementNamed(SignInRoute.routeName);  // go to sign in route
      },
      child: const Icon(Icons.logout, color: Colors.black54),
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap:() {

      },
      child: const Icon(Icons.edit, color: Colors.black54),
    );
  }

  Widget _buildActionsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEditButton(),
          _buildSignOutButton(),
        ],
      ),
    );
  }

  void _dialogAccountDetail(BuildContext context, Account account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          title: _buildTitleRow(account),
          children: [
            const Divider(),
            _buildNameRow(account),
            const Divider(),
            _buildOAuthLinkRow(account),
            const Divider(),
            _buildActionsRow(),
          ],
          elevation: 10.0,
          contentPadding: const EdgeInsets.all(20.0),
        );
      },
    );
  }

  Widget _topPanel(Account account) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _petAvatar,
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
                  onTap: () =>
                  {
                    _dialogAccountDetail(context, account),
                  },
                  child: _userAvatar,
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
    _userAvatar = CircleAvatar(
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
    );
    _petAvatar = CircleAvatar(
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
    );

    return Column(
      children: [
        _topPanel(account),
        Expanded(child: _feedList()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder(
          stream: _bloc.accountSubject,
          builder: (context, AsyncSnapshot<Account?> snapshot) {
            if (snapshot.hasError) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                ErrorDialog().show(context, snapshot.error!);
              });
            }
            if (snapshot.hasData) {
              Account account = snapshot.data!;
              return _feedRoute(account);
            }
            return const SizedBox.shrink();
          },
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
}
