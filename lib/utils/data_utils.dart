import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:intl/intl.dart';

typedef dynamic OnCall(List);

class VarargsFunction extends Function {
  OnCall _onCall;

  VarargsFunction(this._onCall);

  call() => _onCall([]);

  noSuchMethod(Invocation invocation) {
    final arguments = invocation.positionalArguments;
    return _onCall(arguments);
  }
}

int generateId([int length = 10]) {
  if (length < 4 || length > 18) throw Exception('Invalid length');
  String now = DateTime.now().millisecondsSinceEpoch.toString();
  int div = (length / 2).round();
  return int.parse(
    Random().nextInt(10 * div).toString().padLeft(div, '0') +
    now.substring(now.length - div)
  );
}

BigInt generateLargeId([int length = 24]) {
  String now = DateTime.now().millisecondsSinceEpoch.toString();
  int div = (length / 2).round();
  return BigInt.parse(
    Random().nextInt(10 * div).toString().padLeft(div, '0') +
    now.substring(now.length - div)
  );
}

String generateUniqueId(String value) {
  return hex.encode(crypto.md5.convert(Utf8Encoder().convert(value)).bytes);
}
