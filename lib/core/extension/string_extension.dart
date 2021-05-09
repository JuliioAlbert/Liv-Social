import 'package:flutter_translate/flutter_translate.dart';

extension StringExtension on String {
  String localize([List<String> args = const []]) {
    var mapArgs = <String, dynamic>{};
    for (var i = 0; i < args.length; i++) {
      mapArgs.putIfAbsent('%${i + 1}\$s', () => args[i]);
    }
    return translate(this, args: mapArgs);
  }
}
