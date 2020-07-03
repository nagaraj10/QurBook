import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:myfhb/src/model/secretmodel.dart';
class SecretLoader {
  final String secretPath;

  SecretLoader({this.secretPath});


  Future<Secret> load(String key) {
    return rootBundle.loadStructuredData<Secret>(this.secretPath,
            (jsonStr) async {
          final secret = Secret.fromJson(json.decode(jsonStr),key);
          return secret;
        });
  }
}