import 'package:flutter/material.dart';

class Notifications {
  String? fromUserId;
  List? toUserId;
  String? id;
  String? title;
  String? context;
  DateTime? time;

  Notifications(
      {this.fromUserId, this.toUserId, this.id, this.title, this.context, this.time});

  // Factory constructor to instantiate object from json format
  factory Notifications.fromJson(Map<String, dynamic> json) {
    // print(json);
    return Notifications(
        fromUserId: json['fromUserId'],
        toUserId: json['toUserId'],
        id: json['id'],
        title: json['title'],
        context: json['context'],
        time: DateTime.fromMicrosecondsSinceEpoch(
            json['time'].seconds * 1000000));
  }

  Map<String, dynamic> toJson(Notifications notif) {
    return {
      'id': '1',
      'fromUserId': notif.fromUserId,
      'toUserId': notif.toUserId,
      'title': notif.title,
      'context': notif.context,
      'time': notif.time,
    };
  }
}
