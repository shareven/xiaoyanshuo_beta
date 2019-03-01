import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/config/Global.dart';
import 'package:xiaoyanshuo_beta/widgets/AnimationHeart.dart';
import 'package:xiaoyanshuo_beta/widgets/MainDrawer.dart';
import 'package:xiaoyanshuo_beta/widgets/animation/animateHome.dart';

class Home extends StatefulWidget {
  static final String sName = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Global.appName),
        
      ),
      drawer: MainDrawer(),
      body: Center(
       child: PageView(
              children: <Widget>[
                AnimationHeart(),
                Image.asset(Global.bannerImg1),
                Image.asset(Global.bannerImg2),
                Image.asset(Global.bannerImg3),
              ],
            ),
       
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context)=>AnimationDemoHome()  
            )
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.arrow_forward),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
