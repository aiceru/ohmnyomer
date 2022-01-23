import 'package:dartnyom/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:ohmnyomer/src/blocs/feed_bloc_provider.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc_provider.dart';
import 'package:ohmnyomer/src/ui/error_dialog.dart';
import 'package:ohmnyomer/src/ui/feed_route.dart';
import 'package:ohmnyomer/src/ui/validation_mixin.dart';

import 'constants.dart';

class SignUpRoute extends StatefulWidget {
  final int splashIndex;
  const SignUpRoute({Key? key, required this.splashIndex}) : super(key: key);

  @override
  _SignUpRouteState createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> with ValidationMixin {
  late SignBloc bloc;
  final _nameInputController = TextEditingController();
  final _emailInputController = TextEditingController();
  final _passwdInputController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _formValidated = false;

  @override
  void didChangeDependencies() {
    bloc = SignBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget _buildNameTF() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 60.0,
      child: TextFormField(
        validator: (value) => validateName(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _nameInputController,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: Colors.black54,
        ),
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(
            Icons.face,
            color: Colors.black38,
          ),
          hintText: 'Name',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  Widget _buildEmailTF() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 60.0,
      child: TextFormField(
        validator: (value) => validateEmail(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _emailInputController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.black54,
        ),
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(
            Icons.email,
            color: Colors.black38,
          ),
          hintText: 'Email',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  Widget _buildPasswordTF() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 60.0,
      child: TextFormField(
        validator: (value) => validatePassword(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _passwdInputController,
        obscureText: true,
        style: const TextStyle(
          color: Colors.black54,
        ),
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(
            Icons.lock,
            color: Colors.black38,
          ),
          hintText: 'Password',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  void _doSignUp() {
    bloc.signUpWithEmail(
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
        child: const Text(
          'REGISTER',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget _signUpRoute() {
    String splashPath = 'assets/signin/splash-' + widget.splashIndex.toString() + '.jpg';
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(splashPath),
          fit: BoxFit.fitHeight,
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.6), BlendMode.dstATop),
        ),
      ),
      child: Container(
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
                text: 'Sign Up',
                style: kLabelStyle,
              )),
              Form(
                key: _formkey,
                onChanged: () => setState(() => _formValidated = _formkey.currentState!.validate()),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: bloc.accountSubject,
        builder: (context, AsyncSnapshot<Account> snapshot) {
          if (snapshot.hasData) {
            return FeedBlocProvider(child: const FeedRoute());
          } else if (snapshot.hasError) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ErrorDialog().show(context, snapshot.error!);
            });
          }
          return _signUpRoute();
        },
      ),
    );
  }
}

