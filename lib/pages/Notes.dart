import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/pages/NotesCards.dart';
import 'package:xiaoyanshuo_beta/widgets/MainDrawer.dart';


class Notes extends StatefulWidget {
  static final String sName = "/notes";
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  
//每次获取数量
  @override
  void initState() {
    //
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("便签"),
      ),
      drawer: MainDrawer(),
      // body: Text("dddd"),
      body: NotesCards(),
     
    );
  }
}
