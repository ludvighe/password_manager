import 'package:flutter/material.dart';
import 'package:password_manager/utils/encryption.dart';

class PasswordData {
  PasswordData(
      {@required this.title,
      @required this.salt,
      @required this.count,
      @required this.length,
      @required this.created,
      @required this.lastUsed});

  String title, salt;
  int count;
  HashLength length;

  DateTime created;
  DateTime lastUsed;

  String getCreatedString() {
    return created.toIso8601String();
  }
}
