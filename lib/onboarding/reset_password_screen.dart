import 'package:flutter/material.dart';
import 'package:provident_insurance/home/home_tab_screen.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';
import '../constants/image_resource.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String _phoneNumber;
  ResetPasswordScreen(this._phoneNumber);
  @override
  _ResetPasswordScreenState createState() => new _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with TickerProviderStateMixin {
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordAgainController = new TextEditingController();
  TextEditingController _verificationController = new TextEditingController();
  var _isLoading = false;
  FocusNode _focusPassword = new FocusNode();
  FocusNode _focusAgainPassword = new FocusNode();
  FocusNode _focusVerificationCode = new FocusNode();
  String _password = "";
  String _passwordAgain = "";
  String _code = "";

  //MAKE: api call here
  void startApiCall() {
    setState(() {
      this._isLoading = true;
    });
    Navigator.pop(context);
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
    this._password = this._passwordController.text;
    if (this._password.isEmpty) {
      return;
    }
    this.startApiCall();
  }

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
                  "Reset Password",
                  style: new TextStyle(
                      fontSize: 30.0,
                      fontFamily: TextConstant.roboto,
                      color: secondaryColor),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32, right: 32, left: 32),
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusVerificationCode.unfocus();
                },
                validator: (val) => Validator().validatePassword(val!),
                onSaved: (val) => this._code = val!,
                controller: this._verificationController,
                obscureText: false,
                decoration: AppInputDecorator.boxDecorate("Enter code"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32, right: 32, left: 32),
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusPassword.unfocus();
                },
                validator: (val) => Validator().validatePassword(val!),
                onSaved: (val) => this._password = val!,
                controller: this._passwordController,
                obscureText: true,
                decoration: AppInputDecorator.boxDecorate("Enter password"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32, right: 32, left: 32),
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusAgainPassword.unfocus();
                },
                validator: (val) => Validator().validatePassword(val!),
                onSaved: (val) => this._passwordAgain = val!,
                controller: this._passwordAgainController,
                obscureText: true,
                decoration: AppInputDecorator.boxDecorate("Confirm password"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 64, left: 32, right: 32),
              child: TextButton(
                style: WidgetHelper.raisedButtonStyle,
                onPressed: () {
                  this._startCheck();
                },
                child: Text('Reset Password'),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
