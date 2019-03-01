class CostTypeModel {
  String id;
  String name;
  bool isIncome;
  CostTypeModel({this.name,this.isIncome});
  CostTypeModel.fromJson(json)
  :id=json['id'],
  name=json['name'],
  isIncome=json['isIncome'];
}
