import 'package:flutter/material.dart';

class AnimationHeart extends StatefulWidget {
  @override
  _AnimationHeartState createState() => _AnimationHeartState();
}

class _AnimationHeartState extends State<AnimationHeart>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  Animation _animationColor;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    //动画控制器
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    //曲线
    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.bounceOut);

    //动画属性
    _animation = Tween(begin: 32.0, end: 200.0).animate(_curvedAnimation);
    _animationColor = ColorTween(begin: Colors.red, end: Colors.pink)
        .animate(_curvedAnimation);

    // 动画监听
    _animationController.addListener(() {
      print(_animationController.value);
      setState(() {});
    });
    _animationController
        .addStatusListener((AnimationStatus status) => print(status));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeartWidget(
      animationController: _animationController,
      animations: [_animation, _animationColor],
    );
  }
}

class HeartWidget extends AnimatedWidget {
  final List animations;
  final AnimationController animationController;
  HeartWidget({this.animationController, this.animations})
      : super(listenable: animationController);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: Icon(Icons.favorite),
        iconSize: animations[0].value,
        color: animations[1].value,
        onPressed: () {
          switch (animationController.status) {
            case AnimationStatus.completed:
              animationController.reverse();
              break;
            default:
              animationController.forward();
          }
        },
      ),
    );
  }
}
