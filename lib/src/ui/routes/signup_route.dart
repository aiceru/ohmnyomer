import 'package:flutter/material.dart';
import 'package:ohmnyomer/generated/l10n.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/builder_functions.dart';
import 'package:ohmnyomer/src/ui/widgets/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/error_dialog.dart';
import 'package:ohmnyomer/src/ui/routes/feed_route.dart';
import 'package:ohmnyomer/src/ui/validation_mixin.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({Key? key}) : super(key: key);
  static const routeName = '/signUpRoute';

  @override
  _SignUpRouteState createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> with ValidationMixin {
  late SignBloc _bloc;
  final _nameInputController = TextEditingController();
  final _emailInputController = TextEditingController();
  final _passwdInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _formValidated = false;
  bool _init = false;

  @override
  void didChangeDependencies() {
    if (!_init) {
      _bloc = SignBlocProvider.of(context);
      _init = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget _buildNameTF() {
    return buildTextField(Icons.face, S.of(context).name, TextInputType.name,
        validateNameFunc(context), _nameInputController);
  }

  Widget _buildEmailTF() {
    return buildTextField(Icons.email, S.of(context).email, TextInputType.emailAddress,
        validateEmailFunc(context), _emailInputController);
  }

  Widget _buildPasswordTF() {
    return buildTextField(Icons.password, S.of(context).password, TextInputType.visiblePassword,
        validatePasswordFunc(context), _passwdInputController, obsecureText: true);
  }

  void _doSignUp() {
    _bloc.signUpWithEmail(
      context,
      _nameInputController.text,
      _emailInputController.text,
      _passwdInputController.text,
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _formValidated ? _doSignUp : null,
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          S.of(context).register,
          style: const TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget _signUpRoute(String splashPath) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(splashPath),
          fit: BoxFit.fitHeight,
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.6), BlendMode.dstATop),
        ),
      ),
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 100.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(text: TextSpan(
                text: S.of(context).signUp,
                style: kLabelStyle,
              )),
              Form(
                key: _formKey,
                onChanged: () => setState(() => _formValidated = _formKey.currentState!.validate()),
                child: Column(
                  children: [
                    const SizedBox(height: 30.0),
                    _buildNameTF(),
                    const SizedBox(height: 10.0),
                    _buildEmailTF(),
                    const SizedBox(height: 10.0),
                    _buildPasswordTF(),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              _buildRegisterBtn(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final splashPath = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: _bloc.resultSubject,
        builder: (context, AsyncSnapshot<SignInResult> snapshot) {
          if (snapshot.hasData && snapshot.data == SignInResult.success) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.of(context).pushNamedAndRemoveUntil(FeedRoute.routeName, (route) => false);
            });
          } else if (snapshot.hasError) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ErrorDialog().show(context, snapshot.error!);
            });
          }
          return _signUpRoute(splashPath);
        },
      ),
    );
  }
}
