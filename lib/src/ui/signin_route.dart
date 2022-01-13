import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc_provider.dart';
import 'package:ohmnyomer/src/blocs/signin_bloc.dart';
import 'package:ohmnyomer/src/blocs/signin_bloc_provider.dart';
import 'package:ohmnyomer/src/ui/feed_route.dart';

import 'constants.dart';
import 'signup_route.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({Key? key}) : super(key: key);

  @override
  SignInRouteState createState() => SignInRouteState();
}

class SignInRouteState extends State<SignInRoute> {
  late SignInBloc bloc;

  int _splashIndex = 0;
  bool? _rememberMe = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _splashIndex = Random().nextInt(5) + 1;
    });
  }

  @override
  void didChangeDependencies() {
    bloc = SignInBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.black54,
            ),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.black38,
              ),
              hintText: 'Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            style: const TextStyle(
              color: Colors.black54,
            ),
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.black38,
              ),
              hintText: 'Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return GestureDetector(
      onTap: () => print('Forgot Password Button Pressed'),
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Forgot Password?',
          style: kSmallLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: Checkbox(
            value: _rememberMe,
            checkColor: Colors.deepOrangeAccent,
            activeColor: Colors.white,
            onChanged: (value) {
              setState(() {
                _rememberMe = value;
              });
            },
          ),
        ),
        Text(
          'Remember me',
          style: kSmallLabelStyle,
        )
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => print('Login Button Pressed'),
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

  Widget _buildSocialBtn(VoidCallback onTap, ImageProvider img) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
            image: DecorationImage(
              image: img,
              fit: BoxFit.scaleDown,
            )
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSocialBtn(() => {
            buildLoading(context),
            bloc.signInWithGoogle(),
          },
              const Svg('assets/signin/btn_google.svg')),
          _buildSocialBtn(() => {
            buildLoading(context),
            bloc.signInWithKakao(),
          },
            const Svg('assets/signin/btn_kakao.svg')),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupRoute(splashIndex: _splashIndex),
          ),
        );
      },
      child: RichText(
        text: TextSpan(
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

  Widget _signInRoute() {
    String splashPath = 'assets/signin/splash-' + _splashIndex.toString() + '.jpg';
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
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 120.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(text: TextSpan(
                  text: 'Sign In',
                  style: kLabelStyle,
                )),
                const SizedBox(height: 30.0),
                _buildEmailTF(),
                const SizedBox(height: 10.0),
                _buildPasswordTF(),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRememberMeCheckbox(),
                    _buildForgotPasswordBtn(),
                  ],
                ),
                _buildLoginBtn(),
                Text('OR', style: kSmallLabelStyle),
                Text('Sign In with', style: kSmallLabelStyle),
                const SizedBox(height: 20.0),
                _buildSocialBtnRow(),
                const SizedBox(height: 50.0),
                _buildSignupBtn(),
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
          stream: bloc.resultSubject,
          builder: (context, AsyncSnapshot<SignInResult> snapshot) {
            if (snapshot.hasData) {
              var nav = Navigator.of(context);
              if (nav.canPop()) nav.pop();
              if (snapshot.data == SignInResult.success) {
                return FeedBlocProvider(child: FeedRoute());
              }
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return _signInRoute();
          },
        )
    );
  }
}
