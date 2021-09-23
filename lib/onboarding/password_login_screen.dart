import 'package:flutter/material.dart';
import 'package:provident_insurance/api/parse_data.dart';
import 'package:provident_insurance/home/home_tab_screen.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/onboarding/reset_password_screen.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';
import '../constants/image_resource.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/util/pop_up_helper.dart';
import 'package:flutter/services.dart';

class PasswordLoginScreen extends StatefulWidget {
  final String _phoneNumber;
  PasswordLoginScreen(this._phoneNumber);
  @override
  _PasswordLoginScreenState createState() => new _PasswordLoginScreenState();
}

class _PasswordLoginScreenState extends State<PasswordLoginScreen>
    with TickerProviderStateMixin {
  TextEditingController _passwordController = new TextEditingController();
  FocusNode _focusPassword = new FocusNode();
  String _password = "";

  //MAKE: api call here
  void startApiCall(BuildContext context) {
    Map<String, String> data = new Map();
    data.putIfAbsent("phone_number", () => widget._phoneNumber);
    data.putIfAbsent("password", () => this._password);
    final progress = ProgressHUD.of(context);
    progress?.show();
    ApiService().postDataNoHeader(ApiUrl().login(), data).then((value) {
      print(value);
      var result = value["results"];
      DBOperations().insertUser(ParseApiData().parseUser(result));

      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => HomeTabScreen(),
        ),
        (route) => false,
      );
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Login Failed", error.toString())
          .showMessageDialog("OK");
    }).whenComplete(() {
      progress?.dismiss();
    });
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
        body: ProgressHUD(
            child: Builder(
          builder: (context) => _buildMainContentView(context),
        )),
      ),
    );
  }

  //MARK: show dialog to confirm number inputted
  void _startCheck(BuildContext context) {
    this._password = this._passwordController.text.trim();
    if (this._password.isEmpty) {
      PopUpHelper(context, "Login", "Provide a valid pin")
          .showMessageDialog("OK");
      return;
    }
    this.startApiCall(context);
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
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
                decoration: AppInputDecorator.boxDecorate("Enter 6 digit pin"),
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
                  this._startCheck(context);
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
