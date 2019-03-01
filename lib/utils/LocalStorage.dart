import 'package:shared_preferences/shared_preferences.dart';


class LocalStorage {
  
  SharedPreferences prefs ;
  void setBool(key,value) async{
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
}