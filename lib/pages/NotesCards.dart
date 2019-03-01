import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:xiaoyanshuo_beta/model/notes_model.dart';
import 'package:xiaoyanshuo_beta/pages/AddNotes.dart';
import 'package:xiaoyanshuo_beta/pages/EditNotes.dart';
import 'package:xiaoyanshuo_beta/utils/HttpManager.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:xiaoyanshuo_beta/widgets/Notdatafound.dart';

class NotesCards extends StatefulWidget {
  static final String sName = "/NotesCards";
  @override
  _NotesCardsState createState() => _NotesCardsState();
}

class _NotesCardsState extends State<NotesCards> {
  
  DismissDirection _dismissDirection = DismissDirection.endToStart;
  List<NotesModel> _notesList ;
  RefreshController _refreshController;
 
  @override
  void initState() {
    //
    _getNotesData();
    _refreshController = new RefreshController();
    super.initState();
  }



  void _getNotesData() async {
    var response = await HttpManager.request(
        '/notes?filter={"where":{},"order":"updatedAt DESC"}');
    if (response.code == 111) {
       Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response.data),
      ));
    } else {
      List resList = response.data;
      List<NotesModel> notesData = resList.map((v) {
        return new NotesModel.fromJson(v);
      }).toList();
     
      setState(() {
        _notesList = notesData;
      });
    }
  }

  void _handleRefresh(bool up) async {
    if (up) {
      setState(() {});
      await _getNotesData();
      _refreshController.sendBack(true, RefreshStatus.completed);
    } 
  }

  void handleUndo(NotesModel item, int insertionIndex) {
    setState(() {
      _notesList.insert(insertionIndex, item);
    });
  }

  void _handleDelete(NotesModel item) {
    final int insertionIndex = _notesList.indexOf(item);
    setState(() {
      _notesList.remove(item);
    });
    showDialog(
        context: context,
        builder:(BuildContext context)=> AlertDialog(
         content: Text(
           '确定删除以下便签?\n\n${item.updatedAt}\n${item.content}',
           maxLines: 5,
           overflow: TextOverflow.ellipsis,
         ),
          actions: <Widget>[
            FlatButton(
              child: const Text("取消", style: TextStyle(color: Colors.grey)),
              onPressed: () {
                handleUndo(item, insertionIndex);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text("删除", style: TextStyle(color: Colors.pink)),
              onPressed: () {
                _deleteNotes(item, insertionIndex);
                Navigator.pop(context);
              },
            ),
          ], 
        )
        );
  }

  void _deleteNotes(NotesModel item, int insertionIndex) async {
    Map<String, String> data = {"_method": "DELETE"};
    var response = await HttpManager.request('/notes/${item.id}',
        params: data, method: "POST");
    if (response.code == 111) {
      handleUndo(item, insertionIndex); //删除失败，还原数据
       Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response.data),
      ));
    }
  }

  void _goToEditPage(item) async {
    var res = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => EditNotes(notes: item)));
    if (res !=null) {
      //处理页面返回的回调
      int index=_notesList.indexWhere((notes)=>notes.id==item.id);
      setState(() {
        _notesList[index]=NotesModel.fromJson(res);
        _notesList.sort((b,a)=>a.updatedAt.compareTo(b.updatedAt));
      });
    }
  }
  void _goToAddPage() async {
    
    var res = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => AddNotes()));
    if (res !=null) {
      //处理页面返回的回调
      setState(() {
        _notesList.insert(0, NotesModel.fromJson(res));
      });
    }
  }

 

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_notesList==null) {
      body = Center(
        child: CircularProgressIndicator(),
      );
    }else if (_notesList.isEmpty) {
      body = Notdatafound();
    } else {
      body = Container(
        child: SmartRefresher(
          footerBuilder: null,
          enablePullUp: false,
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: (bool up) => _handleRefresh(up),
          child: ListView(
            children: _notesList.map<Widget>((NotesModel item) {
              return _LeaveBehindListItem(
                  dismissDirection: _dismissDirection,
                  item: item,
                  onTap: (val) {
                    _goToEditPage(val);
                  },
                  onDelete: _handleDelete);
            }).toList(),
          ),
        ),
      );
    }

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _goToAddPage,
      ),
    );
  }
}

class _LeaveBehindListItem extends StatelessWidget {
  const _LeaveBehindListItem({
    Key key,
    @required this.item,
    @required this.onDelete,
    @required this.onTap,
    @required this.dismissDirection,
  }) : super(key: key);

  final NotesModel item;
  final DismissDirection dismissDirection;
  final void Function(NotesModel) onDelete;
  final void Function(NotesModel) onTap;

  void _handleDelete() {
    onDelete(item);
  }

  void _handleTap() {
    onTap(item);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
        customSemanticsActions: <CustomSemanticsAction, VoidCallback>{
          // const CustomSemanticsAction(label: '完成'): _handleDelete,
          const CustomSemanticsAction(label: '删除'): _handleDelete,
        },
        child: Dismissible(
          key: ObjectKey(item),
          direction: dismissDirection,
          onDismissed: (DismissDirection direction) {
            _handleDelete();
          },
          background: Container(
              color: theme.primaryColor,
              child: const ListTile(
                  trailing: Icon(Icons.add, color: Colors.white, size: 36.0))),
          secondaryBackground: Container(
              color: theme.primaryColor,
              child: const ListTile(
                  contentPadding: EdgeInsets.all(14.0),
                  trailing:
                      Icon(Icons.delete, color: Colors.white, size: 36.0))),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                  color: theme.canvasColor,
                  border:
                      Border(bottom: BorderSide(color: theme.dividerColor))),
              child: ListTile(
                onTap: _handleTap,
                title: Text(
                  "${item.content}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("${item.updatedAt}"),
              ),
            ),
          ),
        ));
  }
}
