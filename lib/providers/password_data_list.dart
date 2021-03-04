import 'package:flutter/widgets.dart';
import 'package:password_manager/utils/api.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/providers/password_data.dart';

class PasswordDataList extends ChangeNotifier {
  PasswordDataList() {
    _list = List<PasswordData>.empty();
    _list = List.generate(
        5,
        (index) => PasswordData(
            id: 'pdTestID-$index',
            title: "title-$index",
            salt: Encryption.defaultSaltGen(),
            count: Encryption.DEFAULT_COUNT,
            length: HashLength.HL32,
            created: DateTime.now(),
            lastUsed: DateTime.now()));
  }

  static const int SORT_BY_TITLE = 0;
  static const int SORT_BY_CREATED = 1;
  static const int SORT_BY_LAST_USED = 2;

  List<PasswordData> _list;

  // generateId generates a random id with a 'pd' prefix that does not exist in the current _list
  // String generateId() {
  //   String id =
  //       'pd${base64Url.encode(List<int>.generate(16, (index) => Random.secure().nextInt(256)))}';
  //   for (PasswordData passwordData in _list) {
  //     if (passwordData.id == id) generateId();
  //   }
  //   return id;
  // }

  Future<bool> add(String key,
      {String title,
      String url,
      String salt,
      int count,
      HashLength length,
      DateTime created,
      DateTime lastUsed}) async {
    PasswordData passwordData = PasswordData(
        id: null,
        title: title,
        url: url,
        salt: salt,
        count: count,
        length: length,
        created: created,
        lastUsed: lastUsed);
    try {
      await Api.postPasswordData(passwordData, key);
      _list.add(passwordData);
      notifyListeners();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> remove(String key, PasswordData passwordData) async {
    try {
      await Api.deletePasswordData(passwordData.id, key);
      _list.remove(passwordData);
      notifyListeners();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> update(String key, passwordData, String title, String url,
      String salt, int count, HashLength length) async {
    PasswordData tmpPasswordData = passwordData;
    tmpPasswordData.title = title;
    tmpPasswordData.url = url;
    tmpPasswordData.salt = salt;
    tmpPasswordData.count = count;
    tmpPasswordData.length = length;
    try {
      await Api.putPasswordData(tmpPasswordData, key);
      passwordData = tmpPasswordData;
      notifyListeners();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  // Sortinversion keeps track of if the sorting should be inverted
  // [0] = SORT_BY_TITLE
  // [1] = SORT_BY_CREATED
  // [2] = SORT_BY_LAST_USED
  List<bool> sortInversion = [false, false, false];

  void sort(int sortOrder) {
    for (int i = 0; i < 3; i++) {
      if (i == sortOrder) {
        if (i == 0) {
          (sortInversion[0])
              ? _list.sort((a, b) =>
                  b.title.toLowerCase().compareTo(a.title.toLowerCase()))
              : _list.sort((a, b) =>
                  a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        } else if (i == 1) {
          (sortInversion[1])
              ? _list.sort((a, b) => b.created.compareTo(a.created))
              : _list.sort((a, b) => a.created.compareTo(b.created));
        } else if (i == 2) {
          (sortInversion[2])
              ? _list.sort((a, b) => a.lastUsed.compareTo(b.lastUsed))
              : _list.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
        }
        sortInversion[i] = !sortInversion[i];
      } else {
        sortInversion[i] = false;
      }
      notifyListeners();
    }
  }

  void fetchPasswordDataFromApi(String key) async {
    try {
      List<dynamic> json = await Api.getAllPasswordData(key);
      List<PasswordData> fetchedList = List<PasswordData>.empty();
      for (dynamic s in json) {
        fetchedList.add(PasswordData.fromJson(Map.from(s)));
      }
      list = fetchedList;
    } catch (e) {
      print(e);
    }
  }

  void setTitle(PasswordData passwordData, String value) {
    passwordData.title = value;
    notifyListeners();
  }

  void setUrl(PasswordData passwordData, String value) {
    passwordData.url = value;
    notifyListeners();
  }

  void setSalt(PasswordData passwordData, String value) {
    passwordData.salt = value;
    notifyListeners();
  }

  void setCount(PasswordData passwordData, int value) {
    passwordData.count = value;
    notifyListeners();
  }

  void setLength(PasswordData passwordData, HashLength value) {
    passwordData.length = value;
    notifyListeners();
  }

  void setCreated(PasswordData passwordData, DateTime value) {
    passwordData.created = value;
    notifyListeners();
  }

  void setLastUsed(PasswordData passwordData, DateTime value) {
    passwordData.lastUsed = value;
    notifyListeners();
  }

  List<dynamic> get list => _list;

  set list(List<PasswordData> value) {
    _list = value;
    notifyListeners();
  }
}
