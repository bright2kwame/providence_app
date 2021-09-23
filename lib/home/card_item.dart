import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provident_insurance/constants/color.dart';
import 'package:provident_insurance/model/policy_model.dart';
import 'package:provident_insurance/util/widget_helper.dart';

class ProfileCardItem extends StatefulWidget {
  final String title;
  final IconData imageName;
  ProfileCardItem(this.title, this.imageName);

  @override
  _ProfileCardItemState createState() => _ProfileCardItemState();
}

class _ProfileCardItemState extends State<ProfileCardItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Container(
                child: Icon(
                  widget.imageName,
                  size: 70,
                  color: secondaryColor,
                ),
                width: 100,
                height: 100,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class DrawerCardItem extends StatefulWidget {
  final String title;
  final IconData imageName;
  DrawerCardItem(this.title, this.imageName);

  @override
  _DrawerCardItemState createState() => _DrawerCardItemState();
}

class _DrawerCardItemState extends State<DrawerCardItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              child: Icon(
                widget.imageName,
                size: 40,
                color: Colors.red,
              ),
              width: 80,
              height: 80,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              widget.title,
              style: WidgetHelper.textStyle12White,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

//MARK: CarouselCardItem
class CarouselCardItem extends StatefulWidget {
  final Policy policy;
  CarouselCardItem(this.policy);

  @override
  _CarouselCardItemState createState() => _CarouselCardItemState();
}

class _CarouselCardItemState extends State<CarouselCardItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: new Color(widget.policy.colour.hashCode),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                "PROVIDENT INSURANCE",
                style: WidgetHelper.textStyle12White,
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Center(
                child: Text(
                  widget.policy.policyNumber,
                  style: WidgetHelper.textStyle20AcensWhite,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    "Policy Holder",
                    style: WidgetHelper.textStyle12White,
                  ),
                  Expanded(child: Container()),
                  Text(
                    "Expiry",
                    style: WidgetHelper.textStyle12White,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
              child: Row(
                children: [
                  Text(
                    widget.policy.ownerName,
                    style: WidgetHelper.textStyle16AcensWhite,
                  ),
                  Expanded(child: Container()),
                  Text(
                    widget.policy.renewalDate,
                    style: WidgetHelper.textStyle16AcensWhite,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
