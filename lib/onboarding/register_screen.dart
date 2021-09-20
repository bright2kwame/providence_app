import 'package:flutter/material.dart';
import 'package:provident_insurance/api/parse_data.dart';
import 'package:provident_insurance/home/home_tab_screen.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/util/pop_up_helper.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/constants/text_constant.dart';
import 'package:provident_insurance/constants/color.dart';
import '../constants/image_resource.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:flutter/services.dart';

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
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusPassword = new FocusNode();
  FocusNode _focusConfirmPassword = new FocusNode();
  FocusNode _focusFirstName = new FocusNode();
  FocusNode _focusLastName = new FocusNode();
  String _emailAddress = "";
  String _firstName = "";
  String _lastName = "";
  String _password = "";
  String _confirmedPassword = "";

  //MAKE: api call here
  void startApiCall(BuildContext context) {
    Map<String, String> data = new Map();
    data.putIfAbsent("phone_number", () => widget.phoneNumber);
    data.putIfAbsent("password", () => this._password);
    data.putIfAbsent("first_name", () => this._firstName);
    data.putIfAbsent("last_name", () => this._lastName);
    data.putIfAbsent("email", () => this._emailAddress);
    final progress = ProgressHUD.of(context);
    progress?.show();
    ApiService()
        .postDataNoHeader(ApiUrl().completeSignUp(), data)
        .then((value) {
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
      PopUpHelper(context, "Account Creation Failed", error.toString())
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
    this._emailAddress = this._emailController.text.trim();
    this._password = this._passwordController.text.trim();
    this._confirmedPassword = this._confirmPasswordController.text.trim();
    this._firstName = this._firstNameController.text.trim();
    this._lastName = this._lastNameController.text.trim();

    if (!Validator().isValidEmail(this._emailAddress)) {
      PopUpHelper(context, "Required Field", "Provide a valid email address")
          .showMessageDialog("OK");
      return;
    }

    if (this._firstName.isEmpty || this._lastName.isEmpty) {
      PopUpHelper(context, "Required Field", "Provide name")
          .showMessageDialog("OK");
      return;
    }

    if (this._password.isEmpty) {
      PopUpHelper(context, "Required Field", "Provide a valid password")
          .showMessageDialog("OK");
      return;
    }

    if (this._password != this._confirmedPassword) {
      PopUpHelper(context, "Required Field", "Passwords do not match")
          .showMessageDialog("OK");
      return;
    }

    this.startApiCall(context);
  }

  //MARK: take user to terms page
  void _openTermsPage() async {
    const url = 'https://www.providentgh.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                  "Register",
                  style: new TextStyle(
                      fontSize: 30.0,
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
                validator: (val) => Validator().validateEmail(val!),
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
                keyboardType: TextInputType.name,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusFirstName.unfocus();
                },
                validator: (val) => Validator().validateName(val!),
                onSaved: (val) => this._firstName = val!,
                controller: this._firstNameController,
                decoration: AppInputDecorator.boxDecorate("Enter first name"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                style: WidgetHelper.textStyle16,
                textAlign: TextAlign.left,
                onFieldSubmitted: (String value) {
                  _focusLastName.unfocus();
                },
                validator: (val) => Validator().validateName(val!),
                onSaved: (val) => this._lastName = val!,
                controller: this._lastNameController,
                decoration: AppInputDecorator.boxDecorate("Enter last name"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextFormField(
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                maxLength: 6,
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                maxLength: 6,
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
                  this._startCheck(context);
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
