import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/home/card_item.dart';
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
  void _getPolicies() {}
  var policies = ["Policy 1", "Policy 2", "Policy 3"];
  var _currentPage = 1;
  List colors = [Colors.red, Colors.green, Colors.amber, Colors.blue];

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
      ),
      body: _buildMainContentView(context),
    );
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
}
