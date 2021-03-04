import 'dart:convert';

import 'package:password_manager/providers/password_data.dart';
import 'dart:io';

class Database {
  // static Future<File> _passwordDataFile() async {
  //   final path =
  // }

  static File _passwordDataFile() {
    final File jsonFile = File('database/password_data');
    if (jsonFile == null) throw Exception('Could not store password data: File not found.');
    return jsonFile;
  }

  static void storePasswordDataFile(PasswordData passwordData) {
    final File jsonFile = _passwordDataFile();
    jsonFile.writeAsString(passwordData.toJson());
  }

  static Future<List<PasswordData>> loadPasswordDataFile() async {
    final File jsonFile = _passwordDataFile();
    List json = jsonDecode(await jsonFile.readAsString());
    print(json);
    List<PasswordData> list = List<PasswordData>();
    for (dynamic passwordData in json) {
      list.add(PasswordData.fromJson(Map.from(passwordData)));
    }
    return list;
  }
}
