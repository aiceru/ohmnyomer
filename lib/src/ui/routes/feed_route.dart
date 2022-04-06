import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/generated/l10n.dart';
import 'package:ohmnyomer/src/blocs/err_handler.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/ad/ad_helper.dart';
import 'package:ohmnyomer/src/ui/routes/account_route.dart';
import 'package:ohmnyomer/src/ui/routes/pets_route.dart';
import 'package:ohmnyomer/src/ui/timestamp.dart';
import 'package:ohmnyomer/src/ui/widgets/bordered_circle_avatar.dart';
import 'package:ohmnyomer/src/ui/widgets/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/error_dialog.dart';
import 'package:ohmnyomer/src/ui/routes/signin_route.dart';
import 'package:ohmnyomer/src/ui/widgets/dialog_feed_detail.dart';
import 'package:sizer/sizer.dart';

class FeedRoute extends StatefulWidget {
  const FeedRoute({Key? key}) : super(key: key);
  static const routeName = '/feedRoute';

  @override
  _FeedRouteState createState() => _FeedRouteState();
}

class _FeedRouteState extends State<FeedRoute> implements ErrorHandler {
  late FeedBloc _bloc;
  bool _init = false;
  String? _petId;
  BannerAd? _bannerAd;

  late List<Feed> _feeds;
  late Account _account;
  late Map<String, String>? _invitedInfo;

  @override
  void onError(Object e) {
    if (e is GrpcError && e.code == StatusCode.unauthenticated
        && e.message != null && e.message!.contains('token is expired')) {
      ErrorDialog().showAlert(context,
          S.of(context).authTokenExpired,
          S.of(context).pleaseLogInAgain)
          ?.then((_) => Navigator.of(context).pushNamedAndRemoveUntil(
          SignInRoute.routeName, (route) => false));
    } else {
      ErrorDialog().show(context, e);
    }
  }

  @override
  void didChangeDependencies() {
    if (!_init) {
      _bloc = FeedBlocProvider.of(context);
      _bloc.getAccount();
      _init = true;
      AdHelper().loadBanner((ad) => {
        setState(() {
          _bannerAd = ad;
        })
      });
    }
    _invitedInfo = _bloc.fetchInvitedQueries();
    _petId = _bloc.getPetId();
    _bloc.fetchPet(_petId, this);
    _bloc.fetchFeeds(_petId, DateTime.now().toUtc().toSecondsSinceEpoch()+1, 10, this);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bloc.dispose();
    super.dispose();
  }

  Widget _buildTitleRow(Account account) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BorderedCircleAvatar(avatarSizeLarge.w, networkSrc: account.photourl, iconData: Icons.person),
        SizedBox(width: 5.w),
        Expanded(child: Text(account.email, style: TextStyle(fontSize: fontSizeMedium.sp))),
      ],
    );
  }

  Widget _buildNameRow(Account account) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      height: 5.h,
      child: Row(
        children: [
          const Icon(Icons.face, color: Colors.grey),
          SizedBox(width: 9.w),
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
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      height: 5.h,
      child: Row(
        children: [
          const Icon(Icons.link, color: Colors.grey),
          SizedBox(width: 5.w),
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
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      height: 5.h,
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
          contentPadding: EdgeInsets.all(5.w),
        );
      },
    );
  }

  Widget _topPanel() {
    return Container(
        padding: routeTopPanelPadding(),
        child: SizedBox(
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
                    _petId = null;
                  }

                  Pet? p;
                  Widget petAvatar = BorderedCircleAvatar(avatarSizeMedium.w, iconData: Icons.add);
                  String petName = S.of(context).addNewPet;
                  if (snapshot.hasData) {
                    p = snapshot.data!;
                  }
                  if (_petId != null && p != null) {
                    petAvatar = BorderedCircleAvatar(avatarSizeMedium.w, networkSrc: p.photourl, iconData: Icons.pets);
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
                                _petId = value as String?;
                                _bloc.setPetId(_petId);
                              }
                              didChangeDependencies();
                            }),
                          ),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(topPanelTitleLeftPadding.w, 0, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(petName, style: TextStyle(fontSize: fontSizeLarge.sp)),
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
                        child: BorderedCircleAvatar(avatarSizeSmall.w, networkSrc: _account.photourl, iconData: Icons.person),
                      );
                    }
                    return const SizedBox.shrink();
                  })
            ],
          ),
          height: topPanelHeight.h,
        ),
        color: const Color.fromRGBO(33, 87, 82, 0.7)
    );
  }

  deleteFeed(int index) {
    _bloc.deleteFeed(_petId!, _feeds[index].id)
        .then((_) => setState(() => _feeds.removeAt(index)))
        .onError((error, stackTrace) => {if (error != null) onError(error)});
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
            return ListView.separated(
              padding: EdgeInsets.only(top: 0.4.h),
              itemCount: _feeds.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundImage: AssetImage('assets/feed/bowl-full.jpeg'),
                  ),
                  minLeadingWidth: 10.w,
                  title: Text(dateTimeFromEpochSeconds(_feeds[index].timestamp.toInt()).formatDate()),
                  subtitle: Text(dateTimeFromEpochSeconds(_feeds[index].timestamp.toInt()).formatTime()),
                  trailing: Text(_feeds[index].amount.toString() + ' ' + _feeds[index].unit),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  onLongPress: () => _onLongPressFeedItem(index),
                );
                // tileColor: Colors.lightGreenAccent,
              },
              separatorBuilder: (BuildContext context, int index) { return const Divider(); },
            );
          }
          return const SizedBox.shrink();
        }
    );
  }

  bool _isInviteDialogShowing = false;
  Future? _dialogAcceptInvite(String petName, String petFamily) {
    if (!_isInviteDialogShowing) {
      _isInviteDialogShowing = true;
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).invitedCoparenting),
            content: Text(petName + '(' + petFamily + ')'),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(false),
                icon: const Icon(Icons.cancel_outlined, color: Colors.black54,),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.black54),
              )
            ],
          );
        },
      );
    }
    return null;
  }

  Widget _feedRoute() {
    String? id = _invitedInfo?['id'];
    String? name = _invitedInfo?['name'];
    String? family = _invitedInfo?['family'];
    if (id != null && name != null && family != null) {
      debugPrint('==============adding dialog===========');
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _dialogAcceptInvite(name, family)?.then((value) {
          _isInviteDialogShowing = false;
          if (value) {
            _bloc.acceptInvite(id, this).then((_) {
              Navigator.of(context).pushNamed(PetsRoute.routeName).then((ret) {
                if (ret != null) {
                  _petId = ret as String;
                  _bloc.setPetId(_petId);
                  didChangeDependencies();
                }
              });
            });
          }
        });
      });
    }
    return Column(
      children: [
        _topPanel(),
        Expanded(child: _feedList()),
        if (_bannerAd != null)
        AdHelper().bottomBannerWidget(_bannerAd!)
      ],
    );
  }

  addFeed(Feed f) {
    _bloc.addFeed(f)
        .then((value) => setState(() => _feeds.insert(0, value)))
        .onError((error, stackTrace) => {if (error != null) onError(error)});
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
      floatingActionButton: Padding(
          padding: _bannerAd == null ? EdgeInsets.zero : AdHelper().getFabPadding(),
          child: FloatingActionButton(
              onPressed: () {
                _petId == null || _petId!.isEmpty
                    ? null
                    : _dialogFeedDetail(_feeds.isEmpty ? 0.0 : _feeds[0].amount, unitGram, DateTime.now());
              },
              backgroundColor: const Color.fromRGBO(83, 137, 132, 1.0),
              child: const Icon(Icons.add)
          )
      ),
    );
  }
}
