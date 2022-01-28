import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:ohmnyomer/src/blocs/edit_account_bloc.dart';
import 'package:ohmnyomer/src/blocs/edit_account_bloc_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/ui/factory.dart';

class EditAccountRoute extends StatefulWidget {
  const EditAccountRoute({Key? key}) : super(key: key);
  static const routeName = '/EditAccount';

  @override
  _EditAccountRouteState createState() => _EditAccountRouteState();
}

class _EditAccountRouteState extends State<EditAccountRoute> {
  late EditAccountBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = EditAccountBlocProvider.of(context);
    _bloc.fetchAccount();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
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
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BorderedCircleAvatar(account.photourl, 22.0),
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: Text(account.email,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )
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
      color: const Color.fromRGBO(54, 69, 102, 0.7)
    );
  }

  Widget _detailListView(Account account) {
    return ListView(
      padding: const EdgeInsets.all(4.0),
      children: <Widget>[
        ListCard(
          const Icon(Icons.face, size: 32.0),
          account.name,
          'Display name',
        ),
        // for (var info in account.oauthinfo)
        //   ListCard(
        //     Image(image: Svg(ciPathGoogle)),
        //     info.id,
        //     'Linked account',
        //   )
      ],
    );
  }

  Widget _editAccountRoute(Account account) {
    return Column(
      children: [
        _topPanel(account),
        Expanded(child: _detailListView(account)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _bloc.accountSubject,
        builder: (context, AsyncSnapshot<Account> snapshot) {
          if (snapshot.hasData) {
            return _editAccountRoute(snapshot.data!);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
