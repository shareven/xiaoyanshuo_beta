import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/config/Global.dart';
import 'package:xiaoyanshuo_beta/widgets/AnimationHeart.dart';

class Notdatafound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Image.asset(Global.notdatafoundImg),
          Positioned(
            top: 70.0,
            left: 40.0,
            child: AnimationHeart(),
          )
        ],
      ),
    );
  }
}