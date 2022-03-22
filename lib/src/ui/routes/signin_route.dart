import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ohmnyomer/generated/l10n.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/ui/routes/feed_route.dart';
import 'package:ohmnyomer/src/ui/validation_mixin.dart';
import 'package:ohmnyomer/src/ui/widgets/builder_functions.dart';
import 'package:sizer/sizer.dart';

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
  bool _init = false;

  final _emailInputController = TextEditingController();
  final _passwordInputController = TextEditingController();

  StreamBuilder<SharedPrefValues>? _emailTFBuilder;

  @override
  void didChangeDependencies() {
    if (!_init) {
      _bloc = SignBlocProvider.of(context);
      _bloc.getSharedPrefValues();
      _bloc.checkSignInStatus();
      _init = true;
    }
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
        builder: (context, AsyncSnapshot<SharedPrefValues> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.rememberMe) {
              _emailInputController.text = snapshot.data!.lastEmail;
            }
          }
          return buildTextField(Icons.email, S.of(context).email, TextInputType.emailAddress,
              validateEmailFunc(context), _emailInputController);
        }
    );
    return _emailTFBuilder!;
  }

  Widget _buildPasswordTF() {
    return buildTextField(Icons.password, S.of(context).password, TextInputType.visiblePassword,
        validatePasswordFunc(context), _passwordInputController, obsecureText: true);
  }

  Widget _buildForgotPasswordBtn() {
    return GestureDetector(
      onTap: () => print('Forgot Password Button Pressed'),
      child: Container(
        child: smallLabel(S.of(context).forgotPassword),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return StreamBuilder(
        stream: _bloc.valuesSubject,
        builder: (context, AsyncSnapshot<SharedPrefValues> snapshot) {
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
              smallLabel(S.of(context).rememberMe),
            ],
          );
        }
    );
  }

  Widget _buildAutoLoginCheckBox() {
    return StreamBuilder(
      stream: _bloc.valuesSubject,
      builder: (context, AsyncSnapshot<SharedPrefValues> snapshot) {
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
            smallLabel(S.of(context).signInAutomatically),
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
      padding: EdgeInsets.only(top: 3.0.h),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _formValidated ? _doLogin : null,
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          S.of(context).login,
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: fontSizeLarge.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtn(VoidCallback onTap, String provider) {
    return GestureDetector(
      onTap: onTap,
      child: socialLogo(provider, 14.w)
    );
  }

  Widget _buildSocialBtnRow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.w),
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
        text: TextSpan(
          children: [
            TextSpan(
              text: S.of(context).dontHaveAnAccount,
              style: smallLabelTextStyle(),
            ),
            TextSpan(
              text: S.of(context).signUp,
              style: smallLabelTextStyle(),
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
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 15.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(text: TextSpan(
                  text: S.of(context).signIn,
                  style: labelTextStyle(),
                )),
                Form(
                  key: _formKey,
                  onChanged: () => setState(() => _formValidated = _formKey.currentState!.validate()),
                  child: Column(
                    children: [
                      SizedBox(height: 3.5.h),
                      _buildEmailTF(),
                      SizedBox(height: 1.h),
                      _buildPasswordTF(),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRememberMeCheckbox(),
                    _buildForgotPasswordBtn(),
                  ],
                ),
                _buildLoginBtn(),
                _buildAutoLoginCheckBox(),
                SizedBox(height: 2.h),
                smallLabel(S.of(context).or),
                smallLabel(S.of(context).signInWith),
                SizedBox(height: 2.h),
                _buildSocialBtnRow(),
                SizedBox(height: 5.h),
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
