import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/model/notes_model.dart';
import 'package:xiaoyanshuo_beta/utils/HttpManager.dart';
import 'package:xiaoyanshuo_beta/utils/Loading.dart';
import 'package:xiaoyanshuo_beta/utils/ResultData.dart';

class EditNotes extends StatefulWidget {
  NotesModel notes;
  EditNotes({Key key, @required this.notes}) : super(key: key);
  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  String _content;
  String _id;
TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _content=widget.notes.content;
    _id=widget.notes.id;
     _textController=TextEditingController(text: "${widget.notes.content}");
  }

   _saveData() async {
    setState(() {
      _content=_textController.text;
    });
    if (_content != null) {
      Map<String, dynamic> data = {
        "content": _content,
        "_method": "PUT",
      };
      Loading.showLoading(context);
      ResultData res =
          await HttpManager.request('/notes/$_id', method: "POST", params: data);
     
      Loading.hideLoading(context);
      if (res.code != 111) {
        Navigator.pop(context, res.data);
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
            title: Text("编辑便签"),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.done), onPressed: _saveData)
            ],
          ),
          body: Container(
            child: Form(
              child: TextField(
                controller: _textController,
                autofocus: true,
                maxLines: 30,
            // onChanged: (value) {
            //   setState(() {
            //     _content = value;
            //   });
            // },
            decoration: InputDecoration(hintText: "便签,开始记录",),
          ),
        ),
      ),
    );
  }
}
