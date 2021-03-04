import 'dart:convert';

import 'package:flutter/widgets.dart';

class User extends ChangeNotifier {
  User(this.usrId, this.key, this.email);
  String usrId;
  String key;
  String email;

  factory User.empty() {
    return User("", "", "");
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['usrId'], json['key'], json['email']);
  }

  void fetchUserDataFromApi(String key) {
    this.key = key;
    notifyListeners();
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{'usrId': usrId, 'key': key, 'email': email});
  }
}
