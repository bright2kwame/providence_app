import 'package:flutter/material.dart';
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
                        image: AssetImage(ImageResource.appLogo),
                        fit: BoxFit.cover,
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
                    style: WidgetHelper.textStyle20AcensWhite,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Policy ID: 213313",
                    style: WidgetHelper.textStyle16White,
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
                    Container(
                      width: (MediaQuery.of(context).size.width - 32) / 3,
                      child: ProfileCardItem(
                          "Manage Policy", Icons.manage_accounts),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 32) / 3,
                      child: ProfileCardItem(
                          "Quote Calculator", Icons.calculate_outlined),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 32) / 3,
                      child: ProfileCardItem(
                          "New Policy", Icons.new_label_outlined),
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
