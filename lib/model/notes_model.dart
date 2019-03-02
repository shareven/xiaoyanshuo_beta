


import 'package:intl/intl.dart';

class NotesModel implements Comparable<NotesModel>{
  String id;
  String content;
  String updatedAt;
  NotesModel({this.id,this.content,this.updatedAt});
  NotesModel.fromJson(json)
  :id=json['id'],
  content=json['content'],
  // updatedAt=DateTime.now().toUtc().toString();
  // updatedAt=DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse("2002-01-27T14:00:00-0500"));
  updatedAt=DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse("${json['updatedAt'].substring(0,19)}-0801"));
  // updatedAt=DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse("2019-03-01T14:48:28Z"));

   @override
  int compareTo(NotesModel other) => updatedAt.compareTo(other.updatedAt);
}