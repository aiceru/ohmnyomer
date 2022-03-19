import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:ohmnyomer/generated/l10n.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/ui/routes/pets_route.dart';
import 'package:ohmnyomer/src/ui/timestamp.dart';
import 'package:ohmnyomer/src/ui/widgets/bordered_circle_avatar.dart';
import 'package:ohmnyomer/src/ui/widgets/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/error_dialog.dart';
import 'package:ohmnyomer/src/ui/routes/signin_route.dart';
import 'package:ohmnyomer/src/ui/widgets/dialog_feed_detail.dart';

import 'account_route.dart';

class FeedRoute extends StatefulWidget {
  const FeedRoute({Key? key}) : super(key: key);
  static const routeName = '/feedRoute';

  @override
  _FeedRouteState createState() => _FeedRouteState();
}

class _FeedRouteState extends State<FeedRoute> {
  late FeedBloc _bloc;
  bool _init = false;
  String? _petId;

  set petId(String? value) {
    _petId = value;
    _bloc.setPetId(value);
  }

  late List<Feed> _feeds;
  late Account _account;

  @override
  void didChangeDependencies() {
    if (!_init) {
      _bloc = FeedBlocProvider.of(context);
      _bloc.getAccount();
      _init = true;
    }
    _petId = _bloc.getPetId();
    _bloc.fetchPet(_petId);
    _bloc.fetchFeeds(_petId, DateTime.now().toUtc().toSecondsSinceEpoch()+1, 10);
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
        BorderedCircleAvatar(22.0, networkSrc: account.photourl),
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

  Widget _buildOAuthLinkAvatar(String provider) {
    switch (provider) {
      case oauthProviderGoogle:
        return const Image(image: Svg(ciPathGoogle));
      case oauthProviderKakao:
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
          for (var p in account.oauthinfo.keys)
            _buildOAuthLinkAvatar(p),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return IconButton(
      onPressed:() {
        Navigator.of(context).pop();    // dismiss dialog
        _bloc.signOut();
        Navigator.of(context).pushReplacementNamed(SignInRoute.routeName);  // go to sign in route
      },
      icon: const Icon(Icons.logout, color: Colors.black54),
    );
  }

  Widget _buildEditButton() {
    return IconButton(
      onPressed:() {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AccountRoute.routeName);  // go to sign in route
      },
      icon: const Icon(Icons.edit, color: Colors.black54),
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

  Widget _topPanel() {
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
                  StreamBuilder(
                    stream: _bloc.petSubject,
                    builder: (context, AsyncSnapshot<Pet?> snapshot) {
                      if (snapshot.hasError) {
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          ErrorDialog().show(context, snapshot.error!);
                        });
                        petId = null;
                      }

                      Pet? p;
                      Widget petAvatar = const BorderedCircleAvatar(22.0, iconData: Icons.add);
                      String petName = S.of(context).addNewPet;
                      if (snapshot.hasData) {
                        p = snapshot.data!;
                      }
                      if (_petId != null && p != null) {
                        petAvatar = BorderedCircleAvatar(22.0, networkSrc: p.photourl, iconData: Icons.pets);
                        petName = p.name;
                      }
                      return Expanded(
                          child:Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: petAvatar,
                                onTap: () => Navigator.of(context).pushNamed(PetsRoute.routeName).then((value) {
                                  if (value != null) {
                                    _bloc.setPetId(value as String?);
                                  }
                                  didChangeDependencies();
                                }),
                              ),
                              Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(petName, style: const TextStyle(fontSize: 22)),
                                  )
                              ),
                            ],
                          )
                      );
                    },
                  ),
                  StreamBuilder(
                      stream: _bloc.accountSubject,
                      builder: (context, AsyncSnapshot<Account?> snapshot) {
                        if (snapshot.hasError) {
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            ErrorDialog().show(context, snapshot.error!);
                          });
                        }
                        if (snapshot.hasData) {
                          _account = snapshot.data!;
                          return GestureDetector(
                            onTap: () => _dialogAccountDetail(context, _account),
                            child: BorderedCircleAvatar(20.0, networkSrc: _account.photourl),
                          );
                        }
                        return const SizedBox.shrink();
                      })
                ],
              ),
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.1,
            )
          ],
        ),
        color: const Color.fromRGBO(33, 87, 82, 0.7)
    );
  }

  deleteFeed(int index) {
    _bloc.deleteFeed(_petId!, _feeds[index].id)
        .then((value) => setState(() => {
      _feeds.removeAt(index)
    }));
  }

  void _onLongPressFeedItem(int index) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(S.of(context).feed_delete_confirm),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.cancel_outlined, color: Colors.black54,),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.send, color: Colors.black54),
          )
        ],
      );
    }).then((confirm) => {
      if (confirm) {
        deleteFeed(index)
      }
    });
  }

  Widget _feedList() {
    return StreamBuilder(
        stream: _bloc.feedListSubject,
        builder: (context, AsyncSnapshot<List<Feed>> snapshot) {
          if (snapshot.hasError) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ErrorDialog().show(context, snapshot.error!);
            });
          }
          if (snapshot.hasData) {
            _feeds = snapshot.data!;
            return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.separated(
                  itemCount: _feeds.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundImage: AssetImage('assets/feed/bowl-full.jpeg'),
                      ),
                      minLeadingWidth: 50.0,
                      title: infoTitleText(dateTimeFromEpochSeconds(_feeds[index].timestamp.toInt()).formatDate()),
                      subtitle: infoText(dateTimeFromEpochSeconds(_feeds[index].timestamp.toInt()).formatTime()),
                      trailing: infoTitleText(_feeds[index].amount.toString() + ' ' + _feeds[index].unit),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                      onLongPress: () => _onLongPressFeedItem(index),
                    );
                    // tileColor: Colors.lightGreenAccent,
                  },
                  separatorBuilder: (BuildContext context, int index) { return const Divider(); },
                )
            );
          }
          return const SizedBox.shrink();
        }
    );
  }

  Widget _feedRoute() {
    return Column(
      children: [
        _topPanel(),
        Expanded(child: _feedList()),
      ],
    );
  }

  addFeed(Feed f) {
    _bloc.addFeed(f)
    .then((value) => setState(() {
      _feeds.insert(0, value);
    }));
  }

  void _dialogFeedDetail(double amount, String unit, DateTime t) {
    showDialog(
        context: context,
        builder: (_) {
          return DialogFeedDetail(amount, unit, t);
        }
    ).then((value) {
      if (value != null) {
        Feed f = value;
        f.petId = _petId!;
        f.feederId = _account.id;
        addFeed(f);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: _feedRoute(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _petId == null || _petId!.isEmpty ? null :
              _dialogFeedDetail(0.0, unitGram, DateTime.now());
            },
            backgroundColor: const Color.fromRGBO(83, 137, 132, 1.0),
            child: const Icon(Icons.add)
        )
    );
  }
}
