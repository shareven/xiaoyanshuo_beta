import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoyanshuo_beta/config/Global.dart';
import 'package:xiaoyanshuo_beta/model/cost_type_model.dart';
import 'package:xiaoyanshuo_beta/utils/HttpManager.dart';
import 'package:xiaoyanshuo_beta/utils/Loading.dart';
import 'package:xiaoyanshuo_beta/utils/ResultData.dart';
import 'package:xiaoyanshuo_beta/widgets/dateTimePicker.dart';
import 'package:intl/intl.dart';

class AddAccounts extends StatefulWidget {
  @override
  _AddAccountsState createState() => _AddAccountsState();
}

class _AddAccountsState extends State<AddAccounts> {
  final _formKey = GlobalKey<FormState>();
  var _isIncome = false;
  int _money;
  CostTypeModel _cost_type;
  // Date time;
  DateTime _time = DateTime.now();
  String _remark;
  List<CostTypeModel> _typeList = [];
  List<CostTypeModel> _typeListIsIncome = []; //收入的类型
  List<CostTypeModel> _typeListNotIncome = []; //支出的类型

  void _getCostType() async {
    //loading

    var response = await HttpManager.request('/cost_type');
    if (response.code == 111) {
      print(response.data);
    } else {
      List resList = response.data;
      List<CostTypeModel> typeList = resList.map((v) {
        return new CostTypeModel.fromJson(v);
      }).toList();
    
      setState(() {
        _typeListIsIncome=typeList.where((v)=>v.isIncome).toList();
        _typeListNotIncome=typeList.where((v)=>!v.isIncome).toList();
        _typeList = _typeListNotIncome;
        _cost_type = _typeListNotIncome.first;
      });
    }
  }

  void _saveData() async {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      print("money:$_money");
      print("remark:$_remark");

      Map<String, dynamic> data = {
        "is_income": _isIncome,
        "cost_type": _cost_type.id,
        "money": _money,
        "time": DateFormat("yyyy-MM-dd").format(_time),
        "remark": _remark
      };
      Loading.showLoading(context);
      ResultData res =
          await HttpManager.request('/account', method: "POST", params: data);
      print(res.data);
      Loading.hideLoading(context);
      if (res.code != 111) {
         Navigator.pop(context,res.data);
      } else {
         Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(res.data),
      ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getCostType();
  }

  Widget buildTypeList(BuildContext context) {
    if (_typeList.isNotEmpty) {
      return DropdownButton<CostTypeModel>(
        value: _cost_type,
        onChanged: (CostTypeModel value) {
          setState(() {
            _cost_type = value;
          });
        },
        items: _typeList.map<DropdownMenuItem<CostTypeModel>>((value) {
          return DropdownMenuItem<CostTypeModel>(
            value: value,
            child: Text(value.name, textAlign: TextAlign.center),
          );
        }).toList(),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget buildType(BuildContext context) {
    return InputDecorator(
        decoration: const InputDecoration(
          labelText: "分类",
          hintText: "选择一个分类",
          contentPadding: EdgeInsets.zero,
        ),
        isEmpty: _cost_type == null,
        textAlign: TextAlign.right,
        child: buildTypeList(context));
  }

  void updateType(value) {
    setState(() {
      _isIncome = value;
      _typeList=value?this._typeListIsIncome:this._typeListNotIncome;
       _cost_type = _typeList.first;
    });
  }

  Widget buildIsIcome(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile(
          title: Text("支出"),
          value: false,
          onChanged: (value) {
            updateType(value);
          },
          groupValue: _isIncome,
          activeColor: Global.theme_color,
        ),
        RadioListTile(
          title: Text("收入"),
          value: true,
          onChanged: (value) {
            updateType(value);
          },
          groupValue: _isIncome,
          activeColor: Global.theme_color,
        ),
      ],
    );
  }

  Widget buildTime(BuildContext context) {
    return DateTimePicker(
      labelText: '日期',
      selectedDate: _time,
      selectDate: (DateTime date) {
        setState(() {
          _time = date;
        });
      },
    );
  }

  Widget buildMoney(BuildContext context) {
    return TextFormField(
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
      onSaved: (value) {
        setState(() {
          _money = value == "" ? null : int.parse(value);
        });
      },
      validator: (val) {
        return val == null || val == "" ? "不能为空" : null;
      },
      autofocus: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "金额", prefixText: "\￥", border: OutlineInputBorder()),
    );
  }

  Widget buildRemark(BuildContext context) {
    return TextFormField(
      onSaved: (value) {
        setState(() {
          _remark = value;
        });
      },
      maxLength: 15,
      decoration:
          InputDecoration(labelText: "备注", border: OutlineInputBorder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var formKey = _formKey;
    return Scaffold(
        appBar: new AppBar(
          title: new Text('添加账单'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.done), onPressed: _saveData)
          ],
        ),
        body: DropdownButtonHideUnderline(
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(height: 4),
                buildIsIcome(context),
                SizedBox(height: 20),
                buildType(context),
                SizedBox(height: 20),
                buildTime(context),
                SizedBox(height: 20),
                buildMoney(context),
                SizedBox(height: 20),
                buildRemark(context)
              ],
            ),
          ),
        ));
  }
}
