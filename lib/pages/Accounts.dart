import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/pages/AccountsChart.dart';

class Accounts extends StatefulWidget {
  static final String sName = "/accounts";
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: AccountsChart(),
      //  // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  
}
