import 'package:flutter/material.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import '../constants/color.dart';
import 'card_item.dart';

class DrawerMenuPage extends StatefulWidget {
  DrawerMenuPage({Key? key}) : super(key: key);

  @override
  _DrawerMenuPageState createState() => _DrawerMenuPageState();
}

class _DrawerMenuPageState extends State<DrawerMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: secondaryColor,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.grey,
                      )),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Text(
                      "BUSINESS INSURANCE",
                      textAlign: TextAlign.center,
                      style: WidgetHelper.textStyle16AcensWhite,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child: DrawerCardItem(
                            "Motor\n3rd Party", Icons.pedal_bike_outlined),
                      ),
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child: DrawerCardItem(
                            "Motor Comprehensive", Icons.ac_unit),
                      ),
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child: DrawerCardItem("Motor 3rd Party Fire & Theft",
                            Icons.motorcycle_outlined),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Row(
                    children: [
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child:
                            DrawerCardItem("Burglary\n", Icons.person_outline),
                      ),
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child: DrawerCardItem("Personal Accident",
                            Icons.person_pin_circle_outlined),
                      ),
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child: DrawerCardItem(
                            "Home Owners\n", Icons.home_outlined),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "PERSONAL INSURANCE",
                      textAlign: TextAlign.center,
                      style: WidgetHelper.textStyle16AcensWhite,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child: DrawerCardItem(
                            "Motor\n3rd Party", Icons.motorcycle_outlined),
                      ),
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child: DrawerCardItem(
                            "Motor Comprehensive", Icons.car_repair_outlined),
                      ),
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child: DrawerCardItem("Motor 3rd Party Fire & Theft",
                            Icons.motorcycle_outlined),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "ACCOUNT",
                      textAlign: TextAlign.center,
                      style: WidgetHelper.textStyle16AcensWhite,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child: DrawerCardItem(
                            "Legal", Icons.admin_panel_settings_outlined),
                      ),
                      Container(
                          width: ((MediaQuery.of(context).size.width * 0.75) -
                                  32) /
                              3,
                          child: DrawerCardItem(
                              "Profile", Icons.account_circle_outlined)),
                      Container(
                        width:
                            ((MediaQuery.of(context).size.width * 0.75) - 32) /
                                3,
                        child: DrawerCardItem("About", Icons.info_outline),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
