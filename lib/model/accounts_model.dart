

import 'package:xiaoyanshuo_beta/model/cost_type_model.dart';

class AccountsModel implements Comparable<AccountsModel>{
  String id;
  bool is_income;
  CostTypeModel cost_type;
  int money;
  String time;
  String remark;
  AccountsModel({this.id,this.is_income,this.cost_type,this.money,this.time,this.remark});
  AccountsModel.fromJson(json)
  :id=json['id'],
  is_income=json['is_income'],
  cost_type=CostTypeModel.fromJson(json['cost_type']),
  money=json['money'],
  time=json['time'],
  remark=json['remark'];

   @override
  int compareTo(AccountsModel other) => id.compareTo(other.id);
}