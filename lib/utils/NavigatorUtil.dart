import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/pages/Accounts.dart';
import 'package:xiaoyanshuo_beta/pages/AccountsCards.dart';
import 'package:xiaoyanshuo_beta/pages/Home.dart';
import 'package:xiaoyanshuo_beta/pages/Notes.dart';

class NavigatorUtil {
   ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  ///切换无参数页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  ///home页面
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, Home.sName);
  }

  ///账单页面
  static goAccounts(BuildContext context) {
    Navigator.pushReplacementNamed(context, Accounts.sName);
  }

  ///账单页面
  static goAccountsCard(BuildContext context) {
    Navigator.pushReplacementNamed(context, AccountsCards.sName);
  }

  ///便签页
  static goNotes(BuildContext context) {
    Navigator.pushReplacementNamed(context, Notes.sName);
  }
  
}