import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/utils/HttpManager.dart';
import 'package:xiaoyanshuo_beta/utils/Loading.dart';
import 'package:xiaoyanshuo_beta/utils/ResultData.dart';

class AddNotes extends StatefulWidget {
  @override
  _AddNotesState createState() => _AddNotesState();
}



class _AddNotesState extends State<AddNotes> {

  String _content;

  void _saveData() async {
    if (_content!=null) {
      Map<String, dynamic> data = {
        "content": _content,
      };
      Loading.showLoading(context);
      ResultData res =
          await HttpManager.request('/notes', method: "POST", params: data);
      print(res.data);
      Loading.hideLoading(context);
      if (res.code != 111) {
        Navigator.pop(context,res.data);
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("$res.data"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加便签"),
        actions: <Widget>[
            IconButton(icon: Icon(Icons.done), onPressed: _saveData)
          ],
      ),
      body: Container(
        child: Form(
          child: TextField(
            autofocus: true,
            maxLines: 30,
            onChanged: (value){
              setState(() {
                _content=value;
              });
            },
            
            decoration: InputDecoration(
              hintText: "便签,开始记录"
              
            ),
          ),
        ),
      ),
      );
  }
}