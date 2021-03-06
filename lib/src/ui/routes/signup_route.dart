import 'package:flutter/material.dart';
import 'package:ohmnyomer/generated/l10n.dart';
import 'package:ohmnyomer/src/blocs/err_handler.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc.dart';
import 'package:ohmnyomer/src/blocs/sign_bloc_provider.dart';
import 'package:ohmnyomer/src/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/builder_functions.dart';
import 'package:ohmnyomer/src/ui/widgets/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/error_dialog.dart';
import 'package:ohmnyomer/src/ui/routes/feed_route.dart';
import 'package:ohmnyomer/src/ui/validation_mixin.dart';
import 'package:ohmnyomer/src/ui/widgets/loading_indicator_dialog.dart';
import 'package:sizer/sizer.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({Key? key}) : super(key: key);
  static const routeName = '/signUpRoute';

  @override
  _SignUpRouteState createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> with ValidationMixin implements ErrorHandler {
  late SignBloc _bloc;
  final _nameInputController = TextEditingController();
  final _emailInputController = TextEditingController();
  final _passwdInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _init = false;

  @override
  void onError(Object e) {
    LoadingIndicatorDialog().dismiss();
    ErrorDialog().show(context, e);
  }

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
        validatePasswordFunc(context), _passwdInputController, obscureText: true);
  }

  void _doSignUp() {
    LoadingIndicatorDialog().show(context);
    _bloc.signUpWithEmail(
      _nameInputController.text,
      _emailInputController.text,
      _passwdInputController.text,
      this,
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      width: double.infinity,
      child: StreamBuilder(
        stream: _bloc.formValidationSubject,
        initialData: false,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          bool validated = snapshot.hasData ? snapshot.data! : false;
          return ElevatedButton(
            onPressed: validated ? _doSignUp : null,
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              padding: EdgeInsets.all(4.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Text(
              S.of(context).register,
              style: TextStyle(
                color: const Color(0xFF527DAA),
                letterSpacing: 1.5,
                fontSize: fontSizeLarge.sp,
              ),
            ),
          );
        },
      )
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
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 15.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(text: TextSpan(
                text: S.of(context).signUp,
                style: labelTextStyle(),
              )),
              Form(
                key: _formKey,
                onChanged: () => _bloc.validate(_formKey),
                child: Column(
                  children: [
                    SizedBox(height: 3.5.h),
                    _buildNameTF(),
                    SizedBox(height: 1.h),
                    _buildEmailTF(),
                    SizedBox(height: 1.h),
                    _buildPasswordTF(),
                  ],
                ),
              ),
              SizedBox(height: 1.h),
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
          LoadingIndicatorDialog().dismiss();
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
