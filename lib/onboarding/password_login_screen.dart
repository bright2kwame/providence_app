import 'package:flutter/material.dart';
import 'package:provident_insurance/home/home_tab_screen.dart';
import 'package:provident_insurance/onboarding/reset_password_screen.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';
import '../constants/image_resource.dart';

class PasswordLoginScreen extends StatefulWidget {
  final String _phoneNumber;
  PasswordLoginScreen(this._phoneNumber);
  @override
  _PasswordLoginScreenState createState() => new _PasswordLoginScreenState();
}

class _PasswordLoginScreenState extends State<PasswordLoginScreen>
    with TickerProviderStateMixin {
  TextEditingController _passwordController = new TextEditingController();
  var _isLoading = false;
  FocusNode _focusPassword = new FocusNode();
  String _password = "";

  //MAKE: api call here
  void startApiCall() {
    setState(() {
      this._isLoading = true;
    });
    Navigator.pop(context);
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new HomeTabScreen()));
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

  //MARK: take user to terms page
  void _resetPasswordPage() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            new ResetPasswordScreen(widget._phoneNumber)));
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
                  "Eportal Login",
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
                decoration: AppInputDecorator.boxDecorate("Enter 4 digit pin"),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0, left: 0, right: 20),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        primary: secondaryColor, onSurface: secondaryColor),
                    onPressed: () {
                      this._resetPasswordPage();
                    },
                    child: Text('Reset Password? '),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 64, left: 32, right: 32),
              child: TextButton(
                style: WidgetHelper.raisedButtonStyle,
                onPressed: () {
                  this._startCheck();
                },
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
