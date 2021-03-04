// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager/utils/database.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/providers/password_data.dart';

void main() {
  testWidgets('Test Encryption', (WidgetTester tester) async {
    String salt = Encryption.defaultSaltGen();
    print('SALT: $salt\nSALT LENGTH: ${salt.length}');
    PasswordData passwordData = PasswordData(
        id: 'pdTestID',
        title: "title",
        salt: salt,
        count: Encryption.DEFAULT_COUNT,
        length: HashLength.HL32,
        created: DateTime.now(),
        lastUsed: DateTime.now());
    String masterPassword = "Lorem Ipsum";
    String resultingHash = Encryption.encryptSHA3(
        masterPassword, passwordData.salt, passwordData.count, passwordData.length);
    print('Hash: $resultingHash\nHash length: ${resultingHash.length}');
  });
  testWidgets('Test database', (WidgetTester tester) async {
    Database.storePasswordDataFile(generateTestList()[0]);
    List<PasswordData> list = await Database.loadPasswordDataFile();
    assert(list != null);
  });
}

List<PasswordData> generateTestList() {
  return List.generate(
      10,
      (index) => PasswordData(
          id: 'pdTestID-$index',
          title: "title-$index",
          salt: Encryption.defaultSaltGen(),
          count: Encryption.DEFAULT_COUNT,
          length: HashLength.HL32,
          created: DateTime.now(),
          lastUsed: DateTime.now()));
}
