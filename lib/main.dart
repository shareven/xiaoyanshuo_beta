import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/config/Global.dart';
import 'package:xiaoyanshuo_beta/pages/Accounts.dart';
import 'package:xiaoyanshuo_beta/pages/Home.dart';
import 'package:xiaoyanshuo_beta/pages/Notes.dart';
import 'package:xiaoyanshuo_beta/pages/demo.dart';
import 'package:xiaoyanshuo_beta/widgets/animation/animateHome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '晓艳说',
      theme: ThemeData(
        primarySwatch: Global.theme_color,
      ),
      // initialRoute: "/ ",
      routes: {
        '/demo':(BuildContext context)=>HomeDemo(),
        '/animation':(BuildContext context)=>AnimationDemoHome(),
        '/home':(BuildContext context)=>Home(),
        '/accounts':(BuildContext context)=>Accounts(),
        '/notes':(BuildContext context)=>Notes(),
      },
      home: HomeDemo(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    
    return Home();
  }

  // int page = 0;
  // PageController pageController;

  // @override
  // void initState() {
  //   
  //   super.initState();
  //   pageController = PageController(initialPage: this.page);
  // }

  // @override
  // void dispose() {
  //   
  //   super.dispose();
  //   pageController.dispose();
  // }

  // void onPageChanged(int page) {
  //   setState(() {
  //     this.page = page;
  //   });
  // }

  // void onTap(int index) {
  //   pageController.animateToPage(index,
  //       duration: const Duration(milliseconds: 300), curve: Curves.ease);
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(widget.title),
  //       centerTitle: true,
  //     ),
  //     drawer:MainDrawer(),
  //     body: PageView(
  //       children: <Widget>[Accounts(), Notes()],
  //       controller: pageController,
  //       onPageChanged: onPageChanged,
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       items: [
  //         BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('账单')),
  //         BottomNavigationBarItem(icon: Icon(Icons.note), title: Text('便签')),
  //       ],
  //       currentIndex: page,
  //       onTap: onTap,
  //     ), // This trailing comma makes auto-formatting nicer for build methods.
  //   );
  // }
}
