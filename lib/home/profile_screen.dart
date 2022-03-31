import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/api/parse_data.dart';
import 'package:provident_insurance/constants/number_constant.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/onboarding/splash_screen.dart';
import 'package:provident_insurance/util/pop_up_helper.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import '../constants/color.dart';
import '../constants/image_resource.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = new User();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordAgainController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _verificationCodeController =
      new TextEditingController();
  FocusNode _firstNameFocus = new FocusNode();
  FocusNode _lastNameFocus = new FocusNode();
  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  FocusNode _passwordAgainFocus = new FocusNode();
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _password = "";
  ImagePicker picker = ImagePicker();
  bool updatingAvatar = false;

  @override
  void initState() {
    this._updateUser();
    super.initState();
  }

//MARK: update local db
  _updateUser() {
    DBOperations().getUser().then((value) {
      print(value);
      setState(() {
        this.user = value;
      });
    });
  }

  _startChangePhoneNumber(BuildContext context) {
    String phoneNumber = this._phoneController.text.trim();
    String code = this._verificationCodeController.text.trim();
    if (phoneNumber.isEmpty) {
      PopUpHelper(context, "Profile Update", "Provide a valid phone number")
          .showMessageDialog("OK");
      return;
    }

    if (code.isEmpty) {
      PopUpHelper(context, "Profile Update", "Provide verification code")
          .showMessageDialog("OK");
      return;
    }
    Map<String, String> data = new Map();
    data.putIfAbsent("phone_number", () => this.user.phone);
    data.putIfAbsent("password", () => this._password);
    ProgressHUD.of(context)?.show();
    ApiService.get(this.user.token)
        .putData(ApiUrl().myProfile(), data)
        .then((value) {
      print(value);
      Navigator.pop(context);
      PopUpHelper(context, "Password Change", "Password changed successfully")
          .showMessageDialog("OK");
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Password Change", error.toString())
          .showMessageDialog("OK");
    }).whenComplete(() {
      ProgressHUD.of(context)?.dismiss();
    });
  }

  _startPassword(BuildContext context) {
    this._password = this._passwordController.text.trim();
    String passwordAgain = this._passwordAgainController.text.trim();
    if (this._password.isEmpty) {
      PopUpHelper(context, "Change Password", "Provide a valid password")
          .showMessageDialog("OK");
      return;
    }

    if (this._password != passwordAgain) {
      PopUpHelper(context, "Change Password", "Passwords do not match")
          .showMessageDialog("OK");
      return;
    }
    Map<String, String> data = new Map();
    data.putIfAbsent("phone_number", () => this.user.phone);
    data.putIfAbsent("password", () => this._password);
    ProgressHUD.of(context)?.show();
    ApiService.get(this.user.token)
        .putData(ApiUrl().myProfile(), data)
        .then((value) {
      print(value);
      Navigator.pop(context);
      PopUpHelper(context, "Password Change", "Password changed successfully")
          .showMessageDialog("OK");
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Password Change", error.toString())
          .showMessageDialog("OK");
    }).whenComplete(() {
      ProgressHUD.of(context)?.dismiss();
    });
  }

//MARK: start profile update
  _startProfileUpdate(BuildContext context) {
    this._email = this._emailController.text.trim();
    this._firstName = this._firstNameController.text.trim();
    this._lastName = this._lastNameController.text.trim();
    if (!Validator().isValidEmail(this._email)) {
      PopUpHelper(context, "Profile Update", "Provide a valid email address")
          .showMessageDialog("OK");
      return;
    }
    if (!Validator().isValidName(this._firstName) ||
        !Validator().isValidName(this._lastName)) {
      PopUpHelper(context, "Profile Update", "Provide a valid name")
          .showMessageDialog("OK");
      return;
    }
    Map<String, String> data = new Map();
    data.putIfAbsent("first_name", () => this._firstName);
    data.putIfAbsent("last_name", () => this._lastName);
    data.putIfAbsent("email", () => this._email);
    ProgressHUD.of(context)?.show();
    ApiService.get(this.user.token)
        .putData(ApiUrl().myProfile(), data)
        .then((value) {
      print(value);
      var result = value["results"];
      DBOperations().updateUser(ParseApiData().parseUser(result));
      this._updateUser();
      Navigator.pop(context);
      PopUpHelper(context, "Profile Update", "Profile updated successfully")
          .showMessageDialog("OK");
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Account Creation Failed", error.toString())
          .showMessageDialog("OK");
    }).whenComplete(() {
      ProgressHUD.of(context)?.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: Builder(
      builder: (context) => Container(
          color: secondaryColor,
          child: Column(
            children: [
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: secondaryColor.withAlpha(50), width: 5),
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(100)),
                        child: ClipOval(
                          child: GestureDetector(
                              onTap: () {
                                this._imageSelectorOption();
                              },
                              child: this.updatingAvatar
                                  ? SizedBox(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4,
                                        color: primaryColor,
                                      ),
                                      height: 100.0,
                                      width: 100.0,
                                    )
                                  : this.user.avatar.isEmpty
                                      ? Image.asset(
                                          ImageResource.appLogoSmall,
                                          fit: BoxFit.scaleDown,
                                          width: 100,
                                          height: 100,
                                        )
                                      : new Image(
                                          image: CachedNetworkImageProvider(
                                              this.user.avatar),
                                          fit: BoxFit.cover,
                                          width: 90,
                                          height: 90,
                                        )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        this.user.fullName,
                        style: WidgetHelper.textStyle20AcensWhite,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        this.user.email,
                        style: WidgetHelper.textStyle12White,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child: Container()),
              Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent, width: 0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                  ),
                  child: Container(
                      child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
                          ),
                          child: ListTile(
                            onTap: () {
                              this._changeProfile(context);
                            },
                            title: Text("Profile Settings"),
                            subtitle: Text("change profile Settings"),
                            leading: Icon(
                              Icons.account_circle_outlined,
                              size: 32,
                              color: Colors.blue,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0)),
                          ),
                          child: ListTile(
                            onTap: () {
                              this._changePhoneNumber(context);
                            },
                            title: Text("Phone Number Settings"),
                            subtitle: Text("change phone number"),
                            leading: Icon(
                              Icons.phone_iphone,
                              size: 32,
                              color: Colors.green,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0)),
                          ),
                          child: ListTile(
                            onTap: () {
                              this._changePassword(context);
                            },
                            title: Text("Password Change"),
                            subtitle: Text("change account password"),
                            leading: Icon(
                              Icons.password_outlined,
                              size: 32,
                              color: Colors.amber,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                          ),
                          child: ListTile(
                            title: Text("Logout"),
                            onTap: () {
                              _logOut();
                            },
                            subtitle: Text("log out of account"),
                            leading: Icon(
                              Icons.logout_outlined,
                              size: 32,
                              color: Colors.red,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              )
            ],
          )),
    ));
  }

  void _logOut() {
    PopUpHelper(context, "Log Out", "Proceed to logout of Providence Insurance")
        .showMessageDialogWith("PROCEED", () {
      DBOperations().deleteUser(this.user.id);
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => SplashPage(),
        ),
        (route) => false,
      );
    });
  }

  void _changePhoneNumber(BuildContext buildContext) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: NumberConstant.bottomSheetContentPadding,
                    right: NumberConstant.bottomSheetContentPadding,
                    left: NumberConstant.bottomSheetContentPadding),
                child: Text(
                  "Enter phone and proceed to verify",
                  style: WidgetHelper.textStyle16LightGray,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 16,
                    right: NumberConstant.bottomSheetContentPadding,
                    left: NumberConstant.bottomSheetContentPadding,
                    bottom: 16),
                child: TextFormField(
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: WidgetHelper.textStyle16,
                  textAlign: TextAlign.left,
                  onFieldSubmitted: (String value) {
                    _passwordFocus.unfocus();
                  },
                  controller: this._phoneController,
                  obscureText: true,
                  decoration: AppInputDecorator.boxDecorate("Enter new number"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 16,
                    right: NumberConstant.bottomSheetContentPadding,
                    left: NumberConstant.bottomSheetContentPadding,
                    bottom: 16),
                child: TextFormField(
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: WidgetHelper.textStyle16,
                  textAlign: TextAlign.left,
                  controller: this._verificationCodeController,
                  decoration:
                      AppInputDecorator.boxDecorate("Enter verification code"),
                ),
              ),
              SafeArea(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 32, left: 32, right: 32),
                child: TextButton(
                  style: WidgetHelper.raisedButtonStyle,
                  onPressed: () {
                    this._startChangePhoneNumber(buildContext);
                  },
                  child: Text('Update Phone Number'),
                ),
              ))
            ],
          );
        });
  }

  void _changePassword(BuildContext buildContext) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: NumberConstant.bottomSheetContentPadding,
                        right: NumberConstant.bottomSheetContentPadding,
                        left: NumberConstant.bottomSheetContentPadding),
                    child: Text(
                      "Provide the information below to change password",
                      style: WidgetHelper.textStyle16LightGray,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 16,
                        right: NumberConstant.bottomSheetContentPadding,
                        left: NumberConstant.bottomSheetContentPadding,
                        bottom: 16),
                    child: TextFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: WidgetHelper.textStyle16,
                      textAlign: TextAlign.left,
                      onFieldSubmitted: (String value) {
                        _passwordFocus.unfocus();
                      },
                      validator: (val) => Validator().validatePassword(val!),
                      onSaved: (val) => this._password = val!,
                      controller: this._passwordController,
                      obscureText: true,
                      decoration:
                          AppInputDecorator.boxDecorate("Current password"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 16,
                        right: NumberConstant.bottomSheetContentPadding,
                        left: NumberConstant.bottomSheetContentPadding,
                        bottom: 16),
                    child: TextFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: WidgetHelper.textStyle16,
                      textAlign: TextAlign.left,
                      onFieldSubmitted: (String value) {
                        _passwordAgainFocus.unfocus();
                      },
                      validator: (val) => Validator().validatePassword(val!),
                      controller: this._passwordAgainController,
                      obscureText: true,
                      decoration:
                          AppInputDecorator.boxDecorate("Repeat password"),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        top: NumberConstant.bottomSheetContentPadding,
                        left: NumberConstant.bottomSheetContentPadding,
                        right: NumberConstant.bottomSheetContentPadding),
                    child: TextButton(
                      style: WidgetHelper.raisedButtonStyle,
                      onPressed: () {
                        this._startPassword(buildContext);
                      },
                      child: Text('Change Password'),
                    ),
                  )
                ],
              ));
        });
  }

  void _changeProfile(BuildContext buildContext) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: NumberConstant.bottomSheetContentPadding,
                        right: NumberConstant.bottomSheetContentPadding,
                        left: NumberConstant.bottomSheetContentPadding),
                    child: Text(
                      "Provide the information below to update profile",
                      textAlign: TextAlign.center,
                      style: WidgetHelper.textStyle16LightGray,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 32,
                        right: NumberConstant.bottomSheetContentPadding,
                        left: NumberConstant.bottomSheetContentPadding),
                    child: TextFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: WidgetHelper.textStyle16,
                      textAlign: TextAlign.left,
                      onFieldSubmitted: (String value) {
                        _firstNameFocus.unfocus();
                      },
                      validator: (val) => Validator().validateName(val!),
                      onSaved: (val) => this._firstName = val!,
                      controller: this._firstNameController,
                      decoration:
                          AppInputDecorator.boxDecorate("Enter first name"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 16,
                        right: NumberConstant.bottomSheetContentPadding,
                        left: NumberConstant.bottomSheetContentPadding),
                    child: TextFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: WidgetHelper.textStyle16,
                      textAlign: TextAlign.left,
                      onFieldSubmitted: (String value) {
                        _lastNameFocus.unfocus();
                      },
                      validator: (val) => Validator().validateName(val!),
                      onSaved: (val) => this._lastName = val!,
                      controller: this._lastNameController,
                      decoration:
                          AppInputDecorator.boxDecorate("Enter last name"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 16,
                        right: NumberConstant.bottomSheetContentPadding,
                        left: NumberConstant.bottomSheetContentPadding),
                    child: TextFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: WidgetHelper.textStyle16,
                      textAlign: TextAlign.left,
                      onFieldSubmitted: (String value) {
                        _emailFocus.unfocus();
                      },
                      validator: (val) => Validator().validateEmail(val!),
                      onSaved: (val) => this._email = val!,
                      controller: this._emailController,
                      decoration:
                          AppInputDecorator.boxDecorate("Enter email address"),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        top: NumberConstant.bottomSheetContentPadding,
                        left: NumberConstant.bottomSheetContentPadding,
                        right: NumberConstant.bottomSheetContentPadding),
                    child: TextButton(
                      style: WidgetHelper.raisedButtonStyle,
                      onPressed: () {
                        this._startProfileUpdate(buildContext);
                      },
                      child: Text('Update Profile'),
                    ),
                  )
                ],
              ));
        });
  }

  _imageSelectorOption() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 32, right: 32, left: 16),
                child: Text(
                  "Select Image Source",
                  textAlign: TextAlign.center,
                ),
              ),
              ListTile(
                leading: new Icon(Icons.camera),
                title: new Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  this._cameraPicker(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.photo_album),
                title: new Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  this._galleryPicker(context);
                },
              ),
            ],
          ));
        });
  }

  _galleryPicker(BuildContext buildContext) async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Map<String, String> data = new Map();
      data.putIfAbsent("avatar", () => image.name);
      this._startImageUpload(File(image.path), data);
    } else {
      PopUpHelper(context, "Image Upload", "Unable to upload image")
          .showMessageDialog("OK");
    }
  }

  _cameraPicker(BuildContext context) async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Map<String, String> data = new Map();
      data.putIfAbsent("avatar", () => image.name);
      this._startImageUpload(File(image.path), data);
    } else {
      PopUpHelper(context, "Image Upload", "Unable to upload image")
          .showMessageDialog("OK");
    }
  }

  _startImageUpload(File file, Map<String, String> data) {
    setState(() {
      this.updatingAvatar = true;
    });
    ApiService.get(this.user.token)
        .uploadAvatar("POST", ApiUrl().updateAvatar(), "avatar", file, data)
        .then((value) {
          this._getUserProfile();
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          setState(() {
            this.updatingAvatar = false;
          });
          PopUpHelper(context, "Upload Failed", stackTrace.toString())
              .showMessageDialogWith("OK", () {});
        });
  }

  _getUserProfile() {
    ApiService.get(this.user.token).getData(ApiUrl().myProfile()).then((value) {
      var result = value["results"];
      DBOperations().updateUser(ParseApiData().parseUser(result));
      this._updateUser();
    }).whenComplete(() {
      setState(() {
        this.updatingAvatar = false;
      });
    }).onError((error, stackTrace) {
      PopUpHelper(context, "Upload Failed", stackTrace.toString())
          .showMessageDialogWith("OK", () {});
    });
  }
}
