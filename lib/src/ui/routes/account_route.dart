import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grpc/grpc.dart';
import 'package:ohmnyomer/generated/l10n.dart';
import 'package:ohmnyomer/src/blocs/account_bloc.dart';
import 'package:ohmnyomer/src/blocs/account_bloc_provider.dart';
import 'package:ohmnyomer/src/blocs/err_handler.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/ad/ad_helper.dart';
import 'package:ohmnyomer/src/ui/routes/signin_route.dart';
import 'package:ohmnyomer/src/ui/timestamp.dart';
import 'package:ohmnyomer/src/ui/widgets/bordered_circle_avatar.dart';
import 'package:ohmnyomer/src/ui/widgets/builder_functions.dart';
import 'package:ohmnyomer/src/ui/widgets/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/dialog_text_form_field.dart';
import 'package:ohmnyomer/src/ui/widgets/error_dialog.dart';
import 'package:ohmnyomer/src/ui/validation_mixin.dart';
import 'package:ohmnyomer/src/ui/widgets/image_picker.dart';
import 'package:ohmnyomer/src/ui/widgets/list_card.dart';
import 'package:sizer/sizer.dart';

class AccountRoute extends StatefulWidget {
  const AccountRoute({Key? key}) : super(key: key);
  static const routeName = '/EditAccount';

  @override
  _AccountRouteState createState() => _AccountRouteState();
}

class _AccountRouteState extends State<AccountRoute> with ValidationMixin implements ErrorHandler {
  late AccountBloc _bloc;
  bool _init = false;
  BannerAd? _bannerAd;

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
    if(!_init) {
      _bloc = AccountBlocProvider.of(context);
      _bloc.getAccount();
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

  final TextEditingController _textEditingController = TextEditingController();

  Future<void> _showEditNameDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context)
      {
        _textEditingController.text = '';
        return DialogTextFormField(
          S.of(context).editName,
          labelText: S.of(context).enterNewName,
          validator: validateNameFunc(context),
          inputType: TextInputType.name,
          controller: _textEditingController,
          onSave: () =>
          {
            Navigator.of(context).pop(),
            _bloc.updateName(_textEditingController.text, this),
          }
        );
      },
    );
  }

  Future<void> _showEditPasswordDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context)
      {
        _textEditingController.text = '';
        return DialogTextFormField(
            S.of(context).editPassword,
            labelText: S.of(context).enterNewPassword,
            obscureText: true,
            validator: validatePasswordFunc(context),
            inputType: TextInputType.visiblePassword,
            controller: _textEditingController,
            onSave: () =>
            {
              Navigator.of(context).pop(),
              _bloc.updatePassword(_textEditingController.text, this),
            }
        );
      },
    );
  }

  Future<void> _showDeleteAccountConfirmDialog() async {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(S.of(context).dangerDeleteAccount),
        content: Text(S.of(context).cannotUndo),
        actions: [
          TextButton(
            child: Text(S.of(context).cancel),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(S.of(context).delete),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      );
    }).then((confirm) => {
      if (confirm) {
        _bloc.deleteAccount()
            .then((_) => Navigator.of(context).pushNamedAndRemoveUntil(SignInRoute.routeName, (route) => false))
            .catchError(onError)
      }
    });
  }

  Widget _topPanel(Account account) {
    return Container(
        padding: routeTopPanelPadding(),
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                child: BorderedCircleAvatar(avatarSizeMedium.w, networkSrc: account.photourl, iconData: Icons.person),
                onTap: () => pickAndCropImage((value) => _bloc.uploadProfile(value, this)),
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(topPanelTitleLeftPadding.w, 0, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(account.email,
                      style: TextStyle(fontSize: fontSizeLarge.sp),
                    ),
                  )
              ),
            ],
          ),
          height: topPanelHeight.h,
        ),
        color: const Color.fromRGBO(54, 69, 102, 0.7)
    );
  }

  Widget _buildNameListCard(Account account) {
    return ListCard(
      Icon(Icons.face, size: iconSize.w),
      account.name,
      S.of(context).tapToEditName,
      onTap: () => _showEditNameDialog(context)
    );
  }

  Widget _buildPasswordListCard(Account account) {
    return ListCard(
      Icon(Icons.password, size: iconSize.w),
      account.hasPassword ? S.of(context).obscuredPassword : S.of(context).passwordNotSet,
      S.of(context).tapToEditPassword,
      onTap: () => _showEditPasswordDialog(context)
    );
  }

  Widget _buildSocialListCards(String provider, Account account) {
    return ListCard(
      socialLogo(provider, socialLogoSize.w),
      account.oauthinfo[provider] == null ?
      S.of(context).oauthNotLinked : account.oauthinfo[provider]!.email,
      S.of(context).linkedAccount,
    );
  }

  Widget _buildSinceListCard(Account account) {
    return ListCard(
      Icon(Icons.access_time, size: iconSize.w),
      dateTimeFromEpochSeconds(account.signedup.toInt()).formatDateTime(),
      S.of(context).joinedAt,
    );
  }

  Widget _buildDeleteAccountCard(Account account) {
    return ListCard(
      Icon(Icons.delete_forever_outlined, size: iconSize.w),
      S.of(context).dangerDeleteAccount,
      S.of(context).signOutAndDeleteAccountForever,
      onTap: () => _showDeleteAccountConfirmDialog(),
    );
  }

  Widget _detailListView(Account account) {
    return ListView(
      padding: routeBodyPadding(),
      children: <Widget>[
        _buildNameListCard(account),
        _buildPasswordListCard(account),
        for (var provider in listProviders)
          _buildSocialListCards(provider, account),
        _buildSinceListCard(account),
        _buildDeleteAccountCard(account),
      ],
    );
  }

  Widget _editAccountRoute(Account account) {
    return Column(
      children: [
        _topPanel(account),
        Expanded(child: _detailListView(account)),
        if (_bannerAd != null)
        AdHelper().bottomBannerWidget(_bannerAd!),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: _bloc.accountSubject,
        builder: (context, AsyncSnapshot<Account> snapshot) {
          if (snapshot.hasData) {
            return _editAccountRoute(snapshot.data!);
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
    );
  }
}
