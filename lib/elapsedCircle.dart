// ignore_for_file: file_names, prefer_const_constructors_in_immutables, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ElapsedCircle extends StatefulWidget {
  /// The color which the widget starts to draw with
  late final Color initialColor;

  /// The color which is used on second iteration of animation
  late final Color secondColor;

  /// The color which is used on third and final iteration of animation
  late final Color lateColor;

  /// How many seconds a full one color draw should take
  late final int expectedSeconds;

  /// Diameter of the circle
  late final double diameter;

  /// How much of the outer bounds should be drawn. If this is
  /// half of diameter then circle should not have transparent center.
  late final double outerBoundsRadius;

  /// When tracking tag is changed then the animation starts anew with
  /// the initial color.
  final String? trackingTag;

  ElapsedCircle({
    Key? key,
    required this.initialColor,
    required this.secondColor,
    required this.lateColor,
    this.expectedSeconds = 5,
    this.diameter = 5,
    this.outerBoundsRadius = 1,
    this.trackingTag,
  }) : super(key: key);

  @override
  State<ElapsedCircle> createState() => _ElapsedCircleState();
}

class _ElapsedCircleState extends State<ElapsedCircle> with TickerProviderStateMixin
{
  late AnimationController controller;
  late Timer timer;
  late List<Color> stagesClrs;
  int milliSecondsElapsed = 0;
  int stage = 0;
  int animationUpdateDurationInMs = 10;
  int get expectedMilliSeconds => widget.expectedSeconds*1000;
  @override
  void initState() {
    stagesClrs = [widget.initialColor,widget.secondColor,widget.lateColor];
    timer = Timer.periodic(Duration(milliseconds: animationUpdateDurationInMs), (timer) { 
    setState(() {
          milliSecondsElapsed+=animationUpdateDurationInMs;
          if(milliSecondsElapsed%expectedMilliSeconds == 0)
          stage++;
          if(stage >= stagesClrs.length)
          {
            stage = stagesClrs.length-1;
            timer.cancel();
          }
        });
    });
    // controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: widget.expectedSeconds),
    // )..addListener(() {
        
    //   });
    // controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    // controller.dispose();
    super.dispose();
  }

  double getProgress()
  {
    if(!timer.isActive)
      return 1;
    return milliSecondsElapsed%expectedMilliSeconds/expectedMilliSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(stagesClrs[stage]),
      value: getProgress(),
    );
  }
}
