import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/config/Global.dart';
import 'package:xiaoyanshuo_beta/utils/NavigatorUtil.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() {
    return new _MainDrawerState();
  }
}

class _MainDrawerState extends State<MainDrawer> {
  List _types;
  BlendMode _selectedBlendMode;
  @override
  void initState() {
    super.initState();
    _types = BlendMode.values;
    _selectedBlendMode = BlendMode.srcOver;
  }
  
  void showDemoDialog<T>({BuildContext context}) {
    showDialog<T>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
            title: Text("设置头像背景主题",textAlign: TextAlign.center),
            children: _types
                .map((v) => SimpleDialogOption(
                    onPressed: () {
                      setState(() {
                        _selectedBlendMode = v;
                      });
                       Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(v.toString(),textAlign: TextAlign.center),
                    )))
                .toList()))
                .then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("小仙女"),
            accountEmail: Text("晓艳说，爱你哟"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(Global.bannerImg3),
            ),
            decoration: BoxDecoration(
              // color: Theme.of(context).primaryColor,
              image: DecorationImage(
                  image: AssetImage(Global.bannerImg3),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColor.withOpacity(0.8),
                      _selectedBlendMode)),
            ),
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.home,
                            color: Colors.lightBlue,
                          ),
                          title: Text("首页"),
                          onTap: () {
                            NavigatorUtil.goHome(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.developer_mode,
                            color: Colors.lightBlue,
                          ),
                          title: Text("demo"),   
                          onTap: () {
                            NavigatorUtil.pushNamed(context,"/demo");
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.pie_chart,
                            color: Colors.teal,
                          ),
                          title: Text("账单"),
                          onTap: () {
                            NavigatorUtil.goAccounts(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.note,
                            color: Colors.cyan,
                          ),
                          title: Text("便签"),
                          onTap: () {
                            NavigatorUtil.goNotes(context);
                          },
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.settings, color: Colors.deepPurple),
                          title: Text("设置"),
                          onTap: () {
                            showDemoDialog(context: context);
                          },
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
