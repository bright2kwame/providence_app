import 'package:flutter/material.dart';
import 'package:provident_insurance/onboarding/password_login_screen.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';
import '../constants/image_resource.dart';

class RegisterScreen extends StatefulWidget {
  final String phoneNumber;
  RegisterScreen(this.phoneNumber);

  @override
  _RegisterScreenState createState() => new _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  var _isLoading = false;
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusPassword = new FocusNode();
  FocusNode _focusConfirmPassword = new FocusNode();
  String _emailAddress = "";
  String _password = "";
  String _confirmedPassword = "";

  //MAKE: api call here
  void startApiCall() {
    setState(() {
      this._isLoading = true;
    });

    // Navigator.of(context).push(new MaterialPageRoute(
    //     builder: (BuildContext context) =>
    //         new PasswordLoginScreen(this._phoneNumber)));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: new AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: BackButton(color: secondaryColor)),
        body: _buildMainContentView(context),
      ),
    );
  }

  //MARK: show dialog to confirm number inputted
  void _startCheck() {
    this._emailAddress = this._emailController.text;
    this._password = this._passwordController.text;
    this._confirmedPassword = this._confirmPasswordController.text;

    if (this._emailAddress.isEmpty) {
      print("No number available");
      return;
    }
    this.startApiCall();
  }

  //MARK: take user to terms page
  void _openTermsPage() {}

  Widget _buildMainContentView(context) {
    return new SafeArea(
        child: new Container(
      child: new SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Center(
              child: Container(
                  padding: EdgeInsets.all(16),
                  child: new Image(
                    image: AssetImage(ImageResource.appLogoSmall),
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  )),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Register",
                  style: new TextStyle(
                      fontSize: 40.0,
                      fontFamily: TextConstant.roboto,
                      color: secondaryColor),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusEmail.unfocus();
                },
                validator: (val) => Validator().validateMobile(val!),
                onSaved: (val) => this._emailAddress = val!,
                controller: this._emailController,
                decoration:
                    AppInputDecorator.boxDecorate("Enter email address"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusPassword.unfocus();
                  _focusConfirmPassword.hasFocus;
                },
                obscureText: true,
                validator: (val) => Validator().validatePassword(val!),
                onSaved: (val) => this._password = val!,
                controller: this._passwordController,
                decoration: AppInputDecorator.boxDecorate("Enter pin"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusConfirmPassword.unfocus();
                },
                validator: (val) => Validator().validatePassword(val!),
                onSaved: (val) => this._confirmedPassword = val!,
                controller: this._confirmPasswordController,
                obscureText: true,
                decoration: AppInputDecorator.boxDecorate("Enter pin again"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 64, left: 32, right: 32),
              child: TextButton(
                style: WidgetHelper.raisedButtonStyle,
                onPressed: () {
                  this._startCheck();
                },
                child: Text('Create Account'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 32, right: 32),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    primary: secondaryColor,
                    onSurface: secondaryColor),
                onPressed: () {
                  this._openTermsPage();
                },
                child: Text(
                  'Terms and Conditions',
                  style: WidgetHelper.textStyle12Colored,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
