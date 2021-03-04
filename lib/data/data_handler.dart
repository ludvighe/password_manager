import 'package:password_manager/data/models.dart';
import 'package:password_manager/utils/encryption.dart';

class DataHandler {
  DataHandler({List<PasswordData> passwordDataList}) {
    if (passwordDataList == null) {
      this.passwordDataList = List.generate(
          10,
          (index) => PasswordData(
              title: "Site name $index",
              salt: Encryption.defaultSaltGen(),
              count: Encryption.DEFAULT_COUNT,
              length: HashLength.HL32,
              created: DateTime.now(),
              lastUsed: DateTime.now()));
    } else {
      this.passwordDataList = passwordDataList;
    }
  }

  List<PasswordData> passwordDataList;
}
