import 'package:flutter/material.dart';
import 'package:provident_insurance/policy/add_policy_screen.dart';
import 'package:provident_insurance/policy/policies_screen.dart';
import 'package:provident_insurance/policy/policy_quote.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import '../constants/color.dart';
import '../constants/image_resource.dart';
import 'package:provident_insurance/onboarding/login_screen.dart';
import 'card_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //MARK: navigate to policies
  void _navigateToPolicies() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new PolicieScreen()));
  }

  //MARK: navigate to adding new policy
  void _navigateToNewPolicy() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new AddPolicyScreen()));
  }

  //MARK: navigate to quote on policy
  void _navigateToPolicyQuote() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new PolicyQuoteScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Column(
        children: [
          Expanded(
              child: Container(
            color: secondaryColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: secondaryColor.withAlpha(50), width: 10),
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(100)),
                    child: ClipOval(
                      child: new Image(
                        image: AssetImage(ImageResource.appLogoSmall),
                        fit: BoxFit.scaleDown,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Kwame Dela",
                    style: WidgetHelper.textStyle16White,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                  child: Text(
                    "Policy ID: 213313",
                    style: WidgetHelper.textStyle12White,
                  ),
                )
              ],
            ),
          )),
          Container(
            margin: EdgeInsets.all(16),
            height: (MediaQuery.of(context).size.height / 2) - 32,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        this._navigateToPolicies();
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 32) / 3,
                        child: ProfileCardItem(
                            "Manage Policy", Icons.manage_accounts),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        this._navigateToPolicyQuote();
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 32) / 3,
                        child: ProfileCardItem(
                            "Quote Calculator", Icons.calculate_outlined),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        this._navigateToNewPolicy();
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 32) / 3,
                        child: ProfileCardItem(
                            "New Policy", Icons.new_label_outlined),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 32) / 3,
                      child: ProfileCardItem("File Claim", Icons.reviews),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 32) / 3,
                      child: ProfileCardItem(
                          "Download Sticker", Icons.sticky_note_2),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 32) / 3,
                      child:
                          ProfileCardItem("Near Location", Icons.location_pin),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
