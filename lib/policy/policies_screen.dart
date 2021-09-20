import 'dart:math';
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
import 'package:provident_insurance/constants/text_constant.dart';
import '../constants/image_resource.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PolicieScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PolicieScreenState();
  }
}

class _PolicieScreenState extends State<PolicieScreen> {
  User user = new User();
  var policies = [];
  var _currentPage = 0;
  List colors = [Colors.red, Colors.green, Colors.amber, Colors.blue];
  TextEditingController _vehicleNumberController = new TextEditingController();
  FocusNode _vehicleNumberFocus = new FocusNode();
  String _vehicleNumber = "";

  @override
  void initState() {
    this._updateUser(true);
    super.initState();
  }

  void _getPolicies() {
    ApiService.get(this.user.token)
        .getData(ApiUrl().updateAvatar())
        .then((value) {
          print(value);
          value["results"].forEach((item) {
            this.policies.add(ParseApiData().parsePolicy(item));
          });
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
              onPressed: () {
                this._addExistingPolicy(context);
              },
              child: Text(
                "Add Existing Policy",
                style: WidgetHelper.textStyle16AcensColored,
              )),
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
                  obscureText: true,
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
                    this._startAddingPlolicy(buildContext);
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
                          _currentPage = index;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                    items: policies.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          var activeColor =
                              colors[new Random().nextInt(colors.length)];
                          return CarouselCardItem(i, activeColor);
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
              height: 435,
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
                        title: Text("Date Created"),
                        subtitle: Text("Jan 21, 2021"),
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
                        subtitle: Text("1313123123"),
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
                        title: Text("Discount Earned"),
                        subtitle: Text("GHS 0.0"),
                        leading: Icon(
                          Icons.disc_full_outlined,
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
                        subtitle: Text("Jan 21, 2021"),
                        leading: Icon(
                          Icons.summarize,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: TextButton(
                      style: WidgetHelper.raisedButtonStyle,
                      onPressed: () {},
                      child: Container(
                          width: 200,
                          child: Text(
                            'PAY NOW',
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ),
                ],
              ))
        ],
      ),
    ));
  }

  void _startAddingPlolicy(BuildContext buildContext) {
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
        .postData(ApiUrl().addExistingPolicy(), data)
        .then((value) {
          print(value);
          this._getPolicies();
        })
        .whenComplete(() {})
        .onError((error, stackTrace) {
          print(error);
          PopUpHelper(context, "Policy", "Failed to get managed policies")
              .showMessageDialog("OK");
        });
  }
}
