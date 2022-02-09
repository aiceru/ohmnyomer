import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/ui/routes/feed_route.dart';
import 'package:ohmnyomer/src/ui/validation_mixin.dart';
import 'package:ohmnyomer/src/ui/widgets/builder_functions.dart';

import '../widgets/constants.dart';
import '../widgets/error_dialog.dart';
import 'signup_route.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({Key? key}) : super(key: key);
  static const routeName = '/signInRoute';

  @override
  SignInRouteState createState() => SignInRouteState();
}

class SignInRouteState extends State<SignInRoute> with ValidationMixin {
  late SignBloc _bloc;
  final String _splashPath = 'assets/signin/splash-' + (Random().nextInt(5) + 1).toString() + '.jpg';
  final _formKey = GlobalKey<FormState>();
  bool _formValidated = false;

  final _emailInputController = TextEditingController();
  final _passwordInputController = TextEditingController();

  StreamBuilder<SigningValues>? _emailTFBuilder;

  @override
  void didChangeDependencies() {
    _bloc = SignBlocProvider.of(context);
    _bloc.fetchValues();
    _bloc.checkSignInStatus();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget _buildEmailTF() {
    _emailTFBuilder ??= StreamBuilder(
        stream: _bloc.valuesSubject,
        builder: (context, AsyncSnapshot<SigningValues> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.rememberMe) {
              _emailInputController.text = snapshot.data!.lastEmail;
            }
          }
          return buildTextField(Icons.email, 'Email', TextInputType.emailAddress
              , validateEmail, _emailInputController);
        }
    );
    return _emailTFBuilder!;
  }

  Widget _buildPasswordTF() {
    return buildTextField(Icons.password, 'Password', TextInputType.visiblePassword,
        validatePassword, _passwordInputController, obsecureText: true);
  }

  Widget _buildForgotPasswordBtn() {
    return GestureDetector(
      onTap: () => print('Forgot Password Button Pressed'),
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: smallLabel('Forgot Password?'),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return StreamBuilder(
        stream: _bloc.valuesSubject,
        builder: (context, AsyncSnapshot<SigningValues> snapshot) {
          var rememberMe = snapshot.hasData && snapshot.data != null ? snapshot.data!.rememberMe : false;
          return Row(
            children: [
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: Checkbox(
                  value: rememberMe,
                  checkColor: Colors.deepOrangeAccent,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    _bloc.setRememberMe(value!);
                  },
                ),
              ),
              smallLabel('Remember me'),
            ],
          );
        }
    );
  }

  Widget _buildAutoLoginCheckBox() {
    return StreamBuilder(
      stream: _bloc.valuesSubject,
      builder: (context, AsyncSnapshot<SigningValues> snapshot) {
        var autoSignIn = snapshot.hasData && snapshot.data != null ? snapshot.data!.autoSignIn : false;
        return Row(
          children: [
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: autoSignIn,
                checkColor: Colors.deepOrangeAccent,
                activeColor: Colors.white,
                onChanged: (value) {
                  _bloc.setAutoSignIn(value!);
                },
              ),
            ),
            smallLabel('Sign in automatically'),
          ],
        );
      },
    );
  }

  void _doLogin() {
    _bloc.signInWithEmail(context,
      _emailInputController.text,
      _passwordInputController.text,
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _formValidated ? _doLogin : null,
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtn(VoidCallback onTap, String provider) {
    return GestureDetector(
      onTap: onTap,
      child: socialLogo(provider, 60.0)
    );
  }

  Widget _buildSocialBtnRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSocialBtn(() => _bloc.signInWithGoogle(context),
              oauthProviderGoogle),
          _buildSocialBtn(() => _bloc.signInWithKakao(context),
              oauthProviderKakao),
        ],
      ),
    );
  }

  Widget _buildSignupBtn(String splashPath) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          SignUpRoute.routeName,
          arguments: splashPath,
        );
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account?  ',
              style: kSmallLabelStyle,
            ),
            TextSpan(
              text: 'Sign Up',
              style: kSmallLabelStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _signInRoute(String splashPath) {
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
                RichText(text: const TextSpan(
                  text: 'Sign In',
                  style: kLabelStyle,
                )),
                Form(
                  key: _formKey,
                  onChanged: () => setState(() => _formValidated = _formKey.currentState!.validate()),
                  child: Column(
                    children: [
                      const SizedBox(height: 30.0),
                      _buildEmailTF(),
                      const SizedBox(height: 10.0),
                      _buildPasswordTF(),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRememberMeCheckbox(),
                    _buildForgotPasswordBtn(),
                  ],
                ),
                _buildLoginBtn(),
                _buildAutoLoginCheckBox(),
                const SizedBox(height: 20.0),
                smallLabel('OR'),
                smallLabel('Sign In with'),
                const SizedBox(height: 20.0),
                _buildSocialBtnRow(),
                const SizedBox(height: 50.0),
                _buildSignupBtn(splashPath),
              ],
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder(
          stream: _bloc.resultSubject,
          builder: (context, AsyncSnapshot<SignInResult> snapshot) {
            if (snapshot.hasData && snapshot.data == SignInResult.success) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(FeedRoute.routeName);
              });
            } else if (snapshot.hasError) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                ErrorDialog().show(context, snapshot.error!);
              });
            }
            return _signInRoute(_splashPath);
          },
        )
    );
  }
}