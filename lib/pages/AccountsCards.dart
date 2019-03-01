import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:xiaoyanshuo_beta/model/accounts_model.dart';
import 'package:xiaoyanshuo_beta/utils/HttpManager.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:xiaoyanshuo_beta/widgets/Notdatafound.dart';

class AccountsCards extends StatefulWidget {
   static final String sName = "/accountsCards";
  @override
  _AccountsCardsState createState() => _AccountsCardsState();
}

class _AccountsCardsState extends State<AccountsCards> {
  DismissDirection _dismissDirection = DismissDirection.endToStart;
  List<AccountsModel> _accountsList ;
  RefreshController _refreshController;
  int _countAccounts;
  int _skipNum = 0;
  int _adddataNum = 8; //每次获取数量
  @override
  void initState() {
    // 
    _getAccountsData();
    _getAccountsCountData();
    _refreshController = new RefreshController();
    super.initState();
  }

  // 获取总数量
  void _getAccountsCountData() async {
    var response = await HttpManager.request('/account/count');
    if (response.code == 111) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response.data),
      ));
    } else {
      setState(() {
        _countAccounts = response.data["count"];
      });
    }
  }

  void _getAccountsData() async {
    var response = await HttpManager.request(
        '/account?filter={"where":{},"order":"time DESC","skip":$_skipNum,"limit":$_adddataNum,"include":"cost_typePointer"}');
    if (response.code == 111) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response.data),
      ));
    } else {
      List resList = response.data;
      List<AccountsModel> accountsData = resList.map((v) {
        return new AccountsModel.fromJson(v);
      }).toList();
      List<AccountsModel> newList=_accountsList+accountsData;
      setState(() {
        _accountsList = newList;
      });
    }
  }

  void _handleRefresh(bool up) async{
    if (up) {
      setState(() { });
      _refreshController.sendBack(true, RefreshStatus.idle);
    } else {
      int newSkip = _skipNum + _adddataNum;
      if (newSkip <= _countAccounts) {
        setState(() {
          _skipNum = newSkip;
        });
        await _getAccountsData();
        // _refreshController
        //     .scrollTo(_refreshController.scrollController.offset + 100.0);
        _refreshController.sendBack(false, RefreshStatus.idle);
      }else{
        _refreshController.sendBack(false, RefreshStatus.noMore);
      }
    }
  }

  void handleUndo(AccountsModel item, int insertionIndex) {
    setState(() {
      _accountsList.insert(insertionIndex, item);
    });
  }

  void _handleDelete(AccountsModel item) {
    final int insertionIndex = _accountsList.indexOf(item);
    setState(() {
      _accountsList.remove(item);
    });
    showDialog(
        context: context,
        builder:(BuildContext context)=> AlertDialog(
          content: Text(
              "确定删除以下账单?\n\n\"${item.time} ${item.cost_type.name} ￥${item.money} \""),
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
                _deleteAccount(item, insertionIndex);
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  void _deleteAccount(AccountsModel item, int insertionIndex) async {
    Map<String, String> data = {"_method": "DELETE"};
    var response = await HttpManager.request('/account/${item.id}',
        params: data, method: "POST");
    if (response.code == 111) {
      handleUndo(item, insertionIndex); //删除失败，还原数据
       Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response.data),
      ));
    }
  }


  Widget _footerCreate(BuildContext context, int mode) {
    return new ClassicIndicator(
      mode: mode,
      refreshingText: "",
      idleIcon: new Container(),
      idleText: "Load more...",
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_accountsList==null) {
      body = Center(
        child: CircularProgressIndicator(),
      );
    }else if (_accountsList.isEmpty) {
      body = Notdatafound();
    } else {
      body = Container(
        child: SmartRefresher(
          footerBuilder: _footerCreate,
          enablePullUp: true,
          enablePullDown: false,
          controller: _refreshController,
          onRefresh: (bool up) => _handleRefresh(up),
          child: ListView(
            children: _accountsList.map<Widget>((AccountsModel item) {
              return _LeaveBehindListItem(
                  dismissDirection: _dismissDirection,
                  item: item,
                  onDelete: _handleDelete);
            }).toList(),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("账单列表"),
      ),
      body: body,
      
    );
  }
}

class _LeaveBehindListItem extends StatelessWidget {
  const _LeaveBehindListItem({
    Key key,
    @required this.item,
    @required this.onDelete,
    @required this.dismissDirection,
  }) : super(key: key);

  final AccountsModel item;
  final DismissDirection dismissDirection;
  final void Function(AccountsModel) onDelete;

  void _handleDelete() {
    onDelete(item);
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
                trailing: Icon(Icons.delete, color: Colors.white, size: 36.0))),
        child: Container(
          decoration: BoxDecoration(
              color: theme.canvasColor,
              border: Border(bottom: BorderSide(color: theme.dividerColor))),
          child: ListTile(
              title: Text("￥${item.money}"),
              subtitle: Text("${item.time}\n${item.remark}"),
              trailing: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(item.cost_type.name)),
              isThreeLine: true),
        ),
      ),
    );
  }
}
