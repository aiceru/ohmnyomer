import 'package:dartnyom/protonyom_api_pet.pb.dart';
import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ohmnyomer/generated/l10n.dart';
import 'package:ohmnyomer/src/blocs/pets_bloc.dart';
import 'package:ohmnyomer/src/blocs/pets_bloc_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/ad/ad_helper.dart';
import 'package:ohmnyomer/src/resources/invite/inviter.dart';
import 'package:ohmnyomer/src/ui/timestamp.dart';
import 'package:ohmnyomer/src/ui/widgets/bordered_circle_avatar.dart';
import 'package:ohmnyomer/src/ui/widgets/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/dialog_pet_detail.dart';
import 'package:ohmnyomer/src/ui/widgets/error_dialog.dart';
import 'package:sizer/sizer.dart';

String itemKey(int index, String id) {
  return index.toString() + ':' + id;
}

int indexFromKey(String key) {
  List<String> splits = key.split(':');
  return int.parse(splits[0]);
}

class PetsRoute extends StatefulWidget {
  const PetsRoute({Key? key}) : super(key: key);
  static const routeName = '/Pets';

  @override
  _PetsRouteState createState() => _PetsRouteState();
}

class _PetsRouteState extends State<PetsRoute> {
  Map<String, Family>? _families = {};
  late PetsBloc _bloc;
  late List<Pet> _petList;
  bool _init = false;
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    if (!_init) {
      _bloc = PetsBlocProvider.of(context);
      _bloc.getAccount();
      _bloc.fetchPetList();
      _families = _bloc.getSupportedFamilies();
      _init = true;
      AdHelper().loadBanner((ad) => {
        setState(() {
          _bannerAd = ad;
        })
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bloc.dispose();
    super.dispose();
  }

  void _dialogPetDetail(BuildContext context, Pet? pet) {
    showDialog(
      context: context,
      builder: (_) {
        return DialogPetDetail(_bloc, pet, _families!);
      },
    );
  }

  Widget _buildTopPanelTitleRow(Account account) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BorderedCircleAvatar(avatarSizeMedium.w, networkSrc: account.photourl),
          Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(topPanelTitleLeftPadding.w, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(account.email, style: TextStyle(fontSize: fontSizeLarge.sp)),
              ),
          )
        ],
      ),
      height: 10.h,
    );
  }

  Widget _buildTopPanel() {
    return Container(
        padding: routeTopPanelPadding(),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
            ),
            StreamBuilder(
              stream: _bloc.accountSubject,
              builder: (context, AsyncSnapshot<Account> snapshot) {
                if (snapshot.hasData) {
                  return _buildTopPanelTitleRow(snapshot.data!);
                }
                if (snapshot.hasError) {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    ErrorDialog().show(context, snapshot.error!);
                  });
                  _bloc.getAccount(); // fetch locally saved account
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        color: const Color.fromRGBO(202, 182, 137, 0.7)
    );
  }

  Widget _buildPetListCard(Pet pet) {
    return Card(
        elevation: 2.0,
        margin: EdgeInsets.all(1.w),
        child: InkWell(
            onTap: () => Navigator.of(context).pop(pet.id),
            child: Padding(
                padding: EdgeInsets.fromLTRB(6.w, 5.w, 6.w, 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BorderedCircleAvatar(avatarSizeLarge.w,
                          networkSrc: pet.photourl == '' ? null : pet.photourl,
                          iconData: pet.photourl == '' ? Icons.pets : null,
                        ),
                        Padding(padding: EdgeInsets.only(top: 1.5.h), child: infoText(pet.name)),
                      ],
                    ),
                    // ),
                    // SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.all(1.5.w),
                            child: infoText(
                                _families![pet.family]!.name +
                                    ' ('+ _families![pet.family]!.species[pet.species]! +')'
                            )
                        ),
                        if (pet.adopted.toInt() > 0)
                          Padding(padding: EdgeInsets.all(1.5.w),
                              child: infoText(
                                  S.of(context).adoptedAt + ': ' +
                                      dateTimeFromEpochSeconds(pet.adopted.toInt()).formatDate()
                              )
                          ),
                      ],
                    ),
                    IconButton(
                        onPressed: () => {
                          // TODO: send invite
                          Inviter().share(pet.id, pet.name, pet.family)
                        },
                        icon: Icon(Icons.person_add, color: Colors.black54, size: iconSize.w))
                  ],
                )
            )
        )
    );
  }

  Widget _buildDismissibleListItem(String key, Widget child) {
    return Dismissible(
      key: Key(key),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          int index = indexFromKey(key);
          _bloc.deletePet(_petList[index].id);
        }
      },
      dismissThresholds: const {
        DismissDirection.startToEnd: 0.5,
        DismissDirection.endToStart: 0.5,
      },
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(_petList[indexFromKey(key)].name),
                  content: Text(S.of(context).pet_delete_confirm),
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
              }
          );
        }
        if (direction == DismissDirection.endToStart) {
          _dialogPetDetail(context, _petList[indexFromKey(key)]);
        }
        return Future.value(false);
      },
      background: Container(
          padding: EdgeInsets.only(left: 8.w),
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white, size: iconSize.w),
          color: const Color.fromRGBO(200, 50, 50, 1.0)
      ),
      secondaryBackground: Container(
          padding: EdgeInsets.only(right: 8.w),
          alignment: Alignment.centerRight,
          child: Icon(Icons.edit, color: Colors.white, size: iconSize.w),
          color: const Color.fromRGBO(54, 115, 81, 1.0)
      ),
      child: child,
    );
  }

  Widget _buildPetListView() {
    return StreamBuilder(
      stream: _bloc.petListSubject,
      builder: (context, AsyncSnapshot<List<Pet>> snapshot) {
        if (snapshot.hasError) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            ErrorDialog().show(context, snapshot.error!);
          });
        }
        if (snapshot.hasData && snapshot.data != null) {
          _petList = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(1.w),
            itemCount: _petList.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildDismissibleListItem(
                itemKey(index, _petList[index].id),
                _buildPetListCard(_petList[index]),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _editPetsRoute() {
    return Column(
      children: [
        _buildTopPanel(),
        Expanded(child: _buildPetListView()),
        if (_bannerAd != null)
        AdHelper().bottomBannerWidget(_bannerAd!)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _editPetsRoute(),
        floatingActionButton: Padding(
          padding: AdHelper().getFabPadding(),
          child: FloatingActionButton(
            onPressed: () => {
              _dialogPetDetail(context, null)
            },
            child: const Icon(Icons.add),
            backgroundColor: const Color.fromRGBO(252, 232, 187, 1.0),
            foregroundColor: Colors.black,
          ),
        )
    );
  }
}
