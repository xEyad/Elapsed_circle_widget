// ignore_for_file: file_names, prefer_const_constructors_in_immutables, curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:flutter/material.dart';

///Note that changing parameters requires the use of controller
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

  /// When tracking tag is changed then the animation starts a new with
  /// the initial color.
  final String? trackingTag;

  late ElapsedCircleController? controller;

  ElapsedCircle({
    Key? key,
    required this.initialColor,
    required this.secondColor,
    required this.lateColor,
    this.expectedSeconds = 5,
    this.diameter = 50,
    this.outerBoundsRadius = 5,
    this.trackingTag, 
    this.controller,
  }) : super(key: key)
  {
    if(controller == null)
    {
      controller = ElapsedCircleController().._initialize(
      expectedSeconds:expectedSeconds,
      diameter:diameter,
      outerBoundsRadius:outerBoundsRadius,
      trackingTag:trackingTag,
      initialColor: initialColor, lateColor: lateColor, secondColor: secondColor);
    }
    else if(!controller!._isInitialized)
    {
      controller?._initialize(
      expectedSeconds:expectedSeconds,
      diameter:diameter,
      outerBoundsRadius:outerBoundsRadius,
      trackingTag:trackingTag,
      initialColor: initialColor, lateColor: lateColor, secondColor: secondColor);
    }
    
  }

  @override
  State<ElapsedCircle> createState() => _ElapsedCircleState();
}

class _ElapsedCircleState extends State<ElapsedCircle> with TickerProviderStateMixin
{
  late Timer timer;
  late List<Color> stagesClrs;
  final List<StreamSubscription> _listeners = [];
  int milliSecondsElapsed = 0;
  int stage = 0;
  int animationUpdateDurationInMs = 10;
  int get expectedMilliSeconds => widget.expectedSeconds*1000;
  ElapsedCircleController get _controller => widget.controller!;
  
  @override
  void initState() {
    stagesClrs = [widget.initialColor,widget.secondColor,widget.lateColor];
    initAnimation();
    _controller.addListener(() { 
      reset();
    });
    super.initState();
  }

  void initAnimation()
  {
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
  }

  @override
  void dispose() {
    timer.cancel();
    for (var listener in _listeners) {
      listener.cancel();
    }
    super.dispose();
  }

  void reset()
  {
    milliSecondsElapsed = 0;
    stage = 0;
    timer.cancel();
    initAnimation();
    stagesClrs.clear();
    stagesClrs.addAll([_controller.initialColor,_controller.secondColor,_controller.lateColor]);
  }

  double getProgress()
  {
    if(!timer.isActive)
      return 1;
    return milliSecondsElapsed%expectedMilliSeconds/expectedMilliSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _controller.diameter,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(stagesClrs[stage]),
        value: getProgress(),
        strokeWidth: _controller.outerBoundsRadius,
      ),
    );
  }
}

///more on this pattern can be found here https://www.flutterclutter.dev/flutter/tutorials/create-a-controller-for-a-custom-widget/2021/2149/
class ElapsedCircleController extends ChangeNotifier 
{
  /// The color which the widget starts to draw with
  late Color initialColor;

  /// The color which is used on second iteration of animation
  late Color secondColor;

  /// The color which is used on third and final iteration of animation
  late Color lateColor;

  /// How many seconds a full one color draw should take
  late int expectedSeconds;

  /// Diameter of the circle
  late double diameter;

  /// How much of the outer bounds should be drawn. If this is
  /// half of diameter then circle should not have transparent center.
  late double outerBoundsRadius;

  /// When tracking tag is changed then the animation starts a new with
  /// the initial color.
  String? trackingTag;
  
  bool _isInitialized = false;
  ElapsedCircleController();

  _initialize({
      required Color initialColor,
      required Color secondColor,
      required Color lateColor,
      int expectedSeconds = 5,
      double diameter = 50,
      double outerBoundsRadius = 5,
      String? trackingTag,
    })
    {
      if(_isInitialized)
        return;
      _isInitialized = true;
      this.initialColor = initialColor;
      this.secondColor = secondColor;
      this.lateColor = lateColor;
      this.expectedSeconds = expectedSeconds;
      this.diameter = diameter;
      this.outerBoundsRadius = outerBoundsRadius;
      this.trackingTag = trackingTag;
    }

  ///will cause the indicator to reset if changed
  void updateParameters({
      Color? initialColor,
      Color? secondColor,
      Color? lateColor,
      int? expectedSeconds,
      double? diameter,
      double? outerBoundsRadius,
      String? trackingTag,
    }) 
  {
    if(initialColor!=null)
      this.initialColor = initialColor;

    if(secondColor!=null)
      this.secondColor = secondColor;
      
    if(lateColor!=null)
      this.lateColor = lateColor;
      
    if(expectedSeconds!=null)
      this.expectedSeconds = expectedSeconds;
      
    if(diameter!=null)
      this.diameter = diameter;
      
    if(outerBoundsRadius!=null)
      this.outerBoundsRadius = outerBoundsRadius;
      
    if(trackingTag!=null)
      this.trackingTag = trackingTag;
    
    if(this.outerBoundsRadius > this.diameter/2)
    {
      this.outerBoundsRadius = this.diameter;
    }

    notifyListeners();
  }
}