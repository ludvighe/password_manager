import 'dart:convert';
import 'dart:math';

import 'package:hex/hex.dart';
import 'package:password_manager/providers/password_data.dart';
import 'package:sha3/sha3.dart';

enum HashLength { HL16, HL32, HL64, HL128, HL256 }

class Encryption {
  static final Random _random = Random.secure();

  static const int HASH_LENGTH_16 = 64;
  static const int HASH_LENGTH_32 = 128;
  static const int HASH_LENGTH_64 = 256;
  static const int HASH_LENGTH_128 = 512;
  static const int HASH_LENGTH_256 = 1024;

  static const int DEFAULT_COUNT = 256;

  // Converts enum HashLength to matching output bits to get inquired length
  static int _hashLength(HashLength hl) {
    switch (hl) {
      case HashLength.HL16:
        return HASH_LENGTH_16;
        break;
      case HashLength.HL32:
        return HASH_LENGTH_32;
        break;
      case HashLength.HL64:
        return HASH_LENGTH_64;
        break;
      case HashLength.HL128:
        return HASH_LENGTH_128;
        break;
      case HashLength.HL256:
        return HASH_LENGTH_256;
        break;
      default:
        return 256;
        break;
    }
  }

  // Generates a default salt with 32 characters
  static String defaultSaltGen() {
    var values = List<int>.generate(24, (index) => _random.nextInt(256));
    var result = base64Url.encode(values);

    return result;
  }

  static String encryptSHA3(
      String masterPassword, String salt, int count, HashLength length) {
    String resultingHash = masterPassword + salt;

    for (int i = 0; i < count; i++) {
      var k = SHA3(256, SHA3_PADDING, _hashLength(length));
      k.update(utf8.encode(resultingHash));
      var hash = k.digest();
      resultingHash = HEX.encode(hash);
    }

    return resultingHash;
  }

  static String encryptSHA3FromData(
      String masterPassword, PasswordData passwordData) {
    String resultingHash;
    try {
      resultingHash = masterPassword + passwordData.salt;

      for (int i = 0; i < passwordData.count; i++) {
        var k = SHA3(256, SHA3_PADDING, _hashLength(passwordData.length));
        k.update(utf8.encode(resultingHash));
        var hash = k.digest();
        resultingHash = HEX.encode(hash);
      }
    } catch (e) {
      throw Exception('Could not generate hash:\n$e');
    }

    return resultingHash;
  }
}
