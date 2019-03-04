import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/widgets/demo/slider.dart';

class HomeDemo extends StatefulWidget {
  @override
  _HomeDemoState createState() => _HomeDemoState();
}

class _HomeDemoState extends State<HomeDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SliderDemo(),
      ),
    );
  }
}