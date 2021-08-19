import 'package:flutter/material.dart';
import 'package:provident_insurance/constants/color.dart';
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
              borderRadius: BorderRadius.circular(30),
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
