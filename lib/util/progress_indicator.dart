import 'package:flutter/material.dart';

class ProgressAnimatingIndicator extends StatefulWidget {

  final Color color;
  ProgressAnimatingIndicator({required this.color});
 
  @override
  _ProgressIndicatorState createState() =>
      new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressAnimatingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.repeat();
  }


  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
          height: 2.0,
          padding: EdgeInsets.only(left: 1.0,right: 1.0),
          child:  LinearProgressIndicator( value:  animation.value, backgroundColor: this.widget.color == null ? Theme.of(context).accentColor.withAlpha(100): this.widget.color,),

        )
    );
  }

}