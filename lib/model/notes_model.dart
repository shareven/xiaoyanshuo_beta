


import 'package:intl/intl.dart';

class NotesModel implements Comparable<NotesModel>{
  String id;
  String content;
  String updatedAt;
  NotesModel({this.id,this.content,this.updatedAt});
  NotesModel.fromJson(json)
  :id=json['id'],
  content=json['content'],
  // updatedAt=DateTime.parse(json['updatedAt']);
  updatedAt=DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.parse(json['updatedAt']));

   @override
  int compareTo(NotesModel other) => updatedAt.compareTo(other.updatedAt);
}