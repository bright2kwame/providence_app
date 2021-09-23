import 'package:flutter/material.dart';
import 'package:provident_insurance/api/api_service.dart';
import 'package:provident_insurance/api/api_url.dart';
import 'package:provident_insurance/api/parse_data.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/home/card_item.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/model/policy_model.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/util/pop_up_helper.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import 'package:provident_insurance/util/input_decorator.dart';
import 'package:provident_insurance/util/validator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicieScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PolicieScreenState();
  }
}

class _PolicieScreenState extends State<PolicieScreen> {
  User user = new User();
  List<Policy> policies = [];
  var _currentPage = 0;
  TextEditingController _vehicleNumberController = new TextEditingController();
  FocusNode _vehicleNumberFocus = new FocusNode();
  String _vehicleNumber = "";
  Policy _policy = new Policy();

  @override
  void initState() {
    this._updateUser(true);
    super.initState();
  }

  void _getPolicies() {
    ApiService.get(this.user.token)
        .getData(ApiUrl().managePolicy())
        .then((value) {
          this.policies = [];
          value["results"].forEach((item) {
            this.policies.add(ParseApiData().parsePolicy(item));
          });
          if (this.policies.isNotEmpty) {
            this._policy = this.policies[0];
          }
          setState(() {});
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
        });
  }

//MARK: update local db
  _updateUser(bool fetchData) {
    DBOperations().getUser().then((value) {
      setState(() {
        this.user = value;
      });
      if (fetchData) {
        this._getPolicies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "POLICIES",
          style: WidgetHelper.textStyle16AcensWhite,
        ),
        backgroundColor: secondaryColor,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.new_label,
              color: Colors.white,
            ),
            onPressed: () {
              this._addExistingPolicy(context);
            },
          ),
        ],
      ),
      body: this.policies.isEmpty
          ? _addNewPolicy()
          : _buildMainContentView(context),
    );
  }

  Widget _addNewPolicy() {
    return SafeArea(
        child: Center(
      child: new Column(
        children: [
          Expanded(child: Container()),
          Padding(padding: EdgeInsets.all(16)),
          new TextButton(
            style: WidgetHelper.raisedButtonStyle,
            onPressed: () {
              this._addExistingPolicy(context);
            },
            child: Text(
              "Add Existing Policy",
              style: WidgetHelper.textStyle16AcensWhite,
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    ));
  }

  void _addExistingPolicy(BuildContext buildContext) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 32, right: 32, left: 16),
                child: Text("Enter vehicle number"),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 16, right: 32, left: 16, bottom: 16),
                child: TextFormField(
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: WidgetHelper.textStyle16,
                  textAlign: TextAlign.left,
                  onFieldSubmitted: (String value) {
                    _vehicleNumberFocus.unfocus();
                  },
                  validator: (val) => Validator().validatePassword(val!),
                  onSaved: (val) => this._vehicleNumber = val!,
                  controller: this._vehicleNumberController,
                  decoration:
                      AppInputDecorator.boxDecorate("Vehicle Registration No."),
                ),
              ),
              SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(top: 64, left: 32, right: 32),
                child: TextButton(
                  style: WidgetHelper.raisedButtonStyle,
                  onPressed: () {
                    this._getExistingPlolicy(buildContext);
                  },
                  child: Text('Add Policy'),
                ),
              ))
            ],
          );
        });
  }

  Widget _buildMainContentView(context) {
    return new SafeArea(
        child: new SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: secondaryColor,
            padding: EdgeInsets.only(top: 32, bottom: 16),
            child: Column(
              children: [
                Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 180,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _policy = policies[index];
                          _currentPage = index;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                    items: policies.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return CarouselCardItem(i);
                        },
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: this.policies.map((label) {
                    int index = this.policies.indexOf(label);
                    return Container(
                      width: 12.0,
                      height: 12.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: this._currentPage == index
                            ? Colors.white
                            : Colors.transparent,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(
              height: 500,
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ListTile(
                        title: Text("Date Due"),
                        subtitle: Text(this._policy.renewalDate),
                        leading: Icon(
                          Icons.date_range_outlined,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ListTile(
                        title: Text("Policy Number"),
                        subtitle: Text(this._policy.policyNumber),
                        leading: Icon(
                          Icons.format_list_numbered_outlined,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ListTile(
                        title: Text("Total Due"),
                        subtitle: Text(this._policy.totalPremium),
                        leading: Icon(
                          Icons.summarize,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  this._policy.stickerUrl.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: TextButton(
                            style: WidgetHelper.raisedButtonStyle,
                            onPressed: () {
                              _openLinkPage(this._policy.stickerUrl);
                            },
                            child: Container(
                                width: 200,
                                child: Text(
                                  'DOWNLOAD STICKER',
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        )
                      : Container(),
                  this._policy.certificateUrl.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: TextButton(
                            style: WidgetHelper.raisedButtonStyle,
                            onPressed: () {
                              _openLinkPage(this._policy.certificateUrl);
                            },
                            child: Container(
                                width: 200,
                                child: Text(
                                  'VIEW CERTIFICATE',
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        )
                      : Container(),
                  this._policy.scheduleUrl.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: TextButton(
                            style: WidgetHelper.raisedButtonStyle,
                            onPressed: () {
                              _openLinkPage(this._policy.scheduleUrl);
                            },
                            child: Container(
                                width: 200,
                                child: Text(
                                  'DOWNLOAD STICKER',
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        )
                      : Container(),
                  this._policy.isRenewalDue
                      ? Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: TextButton(
                            style: WidgetHelper.raisedButtonStyle,
                            onPressed: () {
                              _initPayment();
                            },
                            child: Container(
                                width: 200,
                                child: Text(
                                  'PAY NOW',
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        )
                      : Container(),
                ],
              ))
        ],
      ),
    ));
  }

  void _getExistingPlolicy(BuildContext buildContext) {
    this._vehicleNumber = this._vehicleNumberController.text.trim();
    if (this._vehicleNumber.isEmpty) {
      PopUpHelper(context, "Policy", "Enter vehicle registration number")
          .showMessageDialog("OK");
      return;
    }
    Map<String, String> data = new Map();
    data.putIfAbsent("vehicle_registration_number", () => this._vehicleNumber);
    Navigator.pop(context);
    ApiService.get(this.user.token)
        .postData(ApiUrl().getExistingPolicy(), data)
        .then((value) {
          var policyData = value["results"];
          Policy policy = ParseApiData().parsePolicy(policyData);
          String messageToDisplay =
              "Vehicle: ${policy.vehicleMake}\nOwner: ${policy.ownerName}\nTotal Premium: ${policy.totalPremium}\nRenewal Date: ${policy.renewalDate.substring(0, 10)}";
          PopUpHelper(
                  context, "Policy #" + policy.policyNumber, messageToDisplay)
              .showMessageDialogWith("ADD POLICY", () {
            this._addExistingPlolicy(buildContext);
          });
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
          PopUpHelper(context, "Policy", "Failed to get policy")
              .showMessageDialog("OK");
        });
  }

  void _addExistingPlolicy(BuildContext buildContext) {
    this._vehicleNumber = this._vehicleNumberController.text.trim();
    Map<String, String> data = new Map();
    data.putIfAbsent("vehicle_registration_number", () => this._vehicleNumber);
    ApiService.get(this.user.token)
        .postData(ApiUrl().addExistingPolicy(), data)
        .then((value) {
          print(value);
          String message = value["message"];
          PopUpHelper(context, "Added Policy", message)
              .showMessageDialogWith("OK", () {
            this._getPolicies();
          });
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
          PopUpHelper(context, "Policy", "Failed to get managed policies")
              .showMessageDialog("OK");
        });
  }

  void _initPayment() {
    Map<String, String> data = new Map();
    data.putIfAbsent(
        "vehicle_registration_number", () => this._policy.vehicleNumber);
    ApiService.get(this.user.token)
        .postData(ApiUrl().renewPolicy(), data)
        .then((value) {
          print(value);
          String paymentUrl = value["results"]["payment_url"].toString();
          this._openPaymentPage(paymentUrl);
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
          PopUpHelper(context, "Policy", "Failed to get managed policies")
              .showMessageDialog("OK");
        });
  }

  //MARK: take user to terms page
  void _openPaymentPage(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //MARK: take user to stcker url
  void _openLinkPage(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
