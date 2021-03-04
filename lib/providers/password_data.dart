import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:password_manager/utils/encryption.dart';

class PasswordData {
  PasswordData(
      {@required this.id,
      @required String title,
      String url = '',
      @required String salt,
      @required int count,
      @required HashLength length,
      DateTime created,
      DateTime lastUsed}) {
    _title = title;
    _url = url;
    _salt = salt;
    _count = count;
    _length = length;
    _created = (created == null) ? DateTime.now() : created;
    _lastUsed = (lastUsed == null) ? DateTime.now() : lastUsed;
  }

  final String id;
  String _title, _url, _salt;
  int _count;
  HashLength _length;

  DateTime _created, _lastUsed;

  factory PasswordData.fromJson(Map<String, dynamic> json) {
    return PasswordData(
        id: json['id'],
        title: json['title'],
        salt: json['salt'],
        count: json['count'],
        length: HashLength.values
            .firstWhere((e) => e.toString() == json['length']));
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'id': id,
      'title': _title,
      'salt': _salt,
      'count': _count,
      'length': _length.toString(),
      'created': _created.toIso8601String(),
      'lastUsed': _lastUsed.toIso8601String()
    });
  }

  String toString() {
    return _title;
  }

  HashLength _lengthFromString(String value) {
    switch (value) {
      case 'HashLength.HL16':
        return HashLength.HL16;
        break;
      case 'HashLength.HL32':
        return HashLength.HL32;
        break;
      case 'HashLength.HL64':
        return HashLength.HL64;
        break;
      case 'HashLength.HL128':
        return HashLength.HL128;
        break;
      case 'HashLength.HL256':
        return HashLength.HL256;
        break;
    }
    return null;
  }

  String get title => _title;
  String get url => _url;
  String get salt => _salt;
  int get count => _count;
  HashLength get length => _length;
  DateTime get created => _created;
  String get createdToIso8601 => _created.toIso8601String();
  DateTime get lastUsed => _lastUsed;
  String get lastUsedToIso8601 => _lastUsed.toIso8601String();

  set title(String value) {
    _title = value;
  }

  set url(String value) {
    _url = value;
  }

  set salt(String value) {
    _salt = value;
  }

  set count(int value) {
    _count = value;
  }

  set length(HashLength value) {
    _length = value;
  }

  set created(DateTime value) {
    _created = value;
  }

  set lastUsed(DateTime value) {
    _lastUsed = value;
  }
}
