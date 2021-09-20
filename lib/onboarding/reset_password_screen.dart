import 'package:flutter/material.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/util/pop_up_helper.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';
import '../constants/image_resource.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter/services.dart';

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
  FocusNode _focusPassword = new FocusNode();
  FocusNode _focusAgainPassword = new FocusNode();
  FocusNode _focusVerificationCode = new FocusNode();
  String _password = "";
  String _passwordAgain = "";
  String _code = "";

  //MAKE: api call here
  void startApiCall(BuildContext context) {
    this._password = this._passwordController.text.trim();
    this._passwordAgain = this._passwordAgainController.text.trim();
    this._code = this._verificationController.text.trim();

    if (this._code.length != 6) {
      PopUpHelper(context, "Required Field",
              "Provide a valid 6 Digit verificatio code")
          .showMessageDialog("OK");
      return;
    }

    if (this._password != this._passwordAgain) {
      PopUpHelper(context, "Required Field", "Passwords do not match")
          .showMessageDialog("OK");
      return;
    }

    Map<String, String> data = new Map();
    data.putIfAbsent("phone_number", () => widget._phoneNumber);
    data.putIfAbsent("code", () => this._code);
    data.putIfAbsent("new_password", () => this._password);
    final progress = ProgressHUD.of(context);
    progress?.show();
    ApiService().postDataNoHeader(ApiUrl().resetPassword(), data).then((value) {
      PopUpHelper(
              context, "Password Reset", "Successfully resetted your password")
          .showMessageDialogWith("OK", () {
        Navigator.pop(context);
      })();
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Password Reset", error.toString())
          .showMessageDialog("OK");
    }).whenComplete(() {
      progress?.dismiss();
    });
  }

  void initResetApiCall(BuildContext context) {
    Map<String, String> data = new Map();
    data.putIfAbsent("phone_number", () => widget._phoneNumber);
    final progress = ProgressHUD.of(context);
    progress?.show();
    ApiService()
        .postDataNoHeader(ApiUrl().initPasswordReset(), data)
        .then((value) {
      String message = value["message"];
      PopUpHelper(context, "Verification Code", message)
          .showMessageDialog("OK");
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Password Reset", error.toString())
          .showMessageDialog("OK");
    }).whenComplete(() {
      progress?.dismiss();
    });
  }

  @override
  void initState() {
    this.initResetApiCall(context);
    super.initState();
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
      return;
    }
    this.startApiCall(context);
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                maxLength: 6,
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                maxLength: 6,
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
                  this._startCheck(context);
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
