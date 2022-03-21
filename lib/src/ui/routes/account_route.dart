import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ohmnyomer/generated/l10n.dart';
import 'package:ohmnyomer/src/blocs/account_bloc.dart';
import 'package:ohmnyomer/src/blocs/account_bloc_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/resources/admob/ad_helper.dart';
import 'package:ohmnyomer/src/ui/timestamp.dart';
import 'package:ohmnyomer/src/ui/widgets/bordered_circle_avatar.dart';
import 'package:ohmnyomer/src/ui/widgets/builder_functions.dart';
import 'package:ohmnyomer/src/ui/widgets/dialog_text_form_field.dart';
import 'package:ohmnyomer/src/ui/widgets/error_dialog.dart';
import 'package:ohmnyomer/src/ui/validation_mixin.dart';
import 'package:ohmnyomer/src/ui/widgets/list_card.dart';

class AccountRoute extends StatefulWidget {
  const AccountRoute({Key? key}) : super(key: key);
  static const routeName = '/EditAccount';

  @override
  _AccountRouteState createState() => _AccountRouteState();
}

class _AccountRouteState extends State<AccountRoute> with ValidationMixin {
  late AccountBloc _bloc;
  bool _init = false;
  BannerAd? _bannerAd;

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
            _bloc.updateName(context, _textEditingController.text),
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
              _bloc.updatePassword(context, _textEditingController.text),
            }
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
                  BorderedCircleAvatar(22.0, networkSrc: account.photourl),
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

  Widget _buildNameListCard(Account account) {
    return ListCard(
      const Icon(Icons.face, size: 32.0),
      account.name,
      S.of(context).tapToEditName,
      ontap: () => _showEditNameDialog(context)
    );
  }

  Widget _buildPasswordListCard(Account account) {
    return ListCard(
      const Icon(Icons.password, size: 32.0),
      account.hasPassword ? S.of(context).obscuredPassword : S.of(context).passwordNotSet,
      S.of(context).tapToEditPassword,
      ontap: () => _showEditPasswordDialog(context)
    );
  }

  Widget _buildSocialListCards(String provider, Account account) {
    return ListCard(
      socialLogo(provider, 36.0),
      account.oauthinfo[provider] == null ?
      S.of(context).oauthNotLinked : account.oauthinfo[provider]!.email,
      S.of(context).linkedAccount,
    );
  }

  Widget _buildSinceListCard(Account account) {
    return ListCard(
      const Icon(Icons.access_time, size: 32.0),
      dateTimeFromEpochSeconds(account.signedup.toInt()).formatDateTime(),
      S.of(context).joinedAt,
    );
  }

  Widget _detailListView(Account account) {
    return ListView(
      padding: const EdgeInsets.all(4.0),
      children: <Widget>[
        _buildNameListCard(account),
        _buildPasswordListCard(account),
        for (var provider in listProviders)
          _buildSocialListCards(provider, account),
        _buildSinceListCard(account)
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
