import 'package:flutter/material.dart';
import 'package:provident_insurance/model/db_operations.dart';
import 'package:provident_insurance/model/user_model.dart';
import 'package:provident_insurance/policy/add_policy_screen.dart';
import 'package:provident_insurance/policy/file_claim_screen.dart';
import 'package:provident_insurance/policy/policies_screen.dart';
import 'package:provident_insurance/policy/policy_quote.dart';
import 'package:provident_insurance/util/widget_helper.dart';
import '../constants/color.dart';
import '../constants/image_resource.dart';
import 'card_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = new User();

  @override
  void initState() {
    DBOperations().getUser().then((value) {
      print(value);
      setState(() {
        this.user = value;
      });
    });
    super.initState();
  }

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

  //MARK: navigate to file claim
  void _navigateToFileClaim() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new FileClaimScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageResource.bgImage),
                fit: BoxFit.cover,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  color: secondaryColor.withAlpha(970),
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: secondaryColor.withAlpha(50),
                                  width: 10),
                              shape: BoxShape.circle,
                              color: Colors.white.withAlpha(100)),
                          child: ClipOval(
                            child: this.user.avatar.isEmpty
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
                                    width: 100,
                                    height: 100,
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        child: Text(
                          this.user.fullName,
                          style: WidgetHelper.textStyle16White,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Text(
                          "Phone: ${this.user.phone}",
                          style: WidgetHelper.textStyle12White,
                        ),
                      )
                    ],
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
                    GestureDetector(
                      onTap: () {
                        this._navigateToFileClaim();
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 32) / 3,
                        child: ProfileCardItem("File Claim", Icons.reviews),
                      ),
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
