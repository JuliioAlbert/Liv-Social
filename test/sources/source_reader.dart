import 'dart:io';

String source(String name) => File('test/sources/$name').readAsStringSync();
