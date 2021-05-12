import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:liv_social/features/domain/entities/user_model.dart';

import '../../../sources/source_reader.dart';

void main() {
  final user = UserModel(
    name: 'Guillermo De La Cruz Onton',
    uid: '7F9514nzqveH2S6waEgq8G0dAp73',
    email: 'guiller.dlco@gmail.com',
    image:
        'https://lh3.googleusercontent.com/a-/AOh14Gh_Oa5PTMyODnPrytoWf2U8AEeP0JOW40xjn6De9rA=s96-c',
    status: true,
  );

  test(
    'should be a class of UserModel entity',
    () async {
      expect(user, isA<UserModel>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(source('user_model_sample.json'));
        final result = UserModel.fromJson(jsonMap);
        expect(result.toJson(), user.toJson());
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = user.toJson();
        final expectedMap = {
          'name': 'Guillermo De La Cruz Onton',
          'uid': '7F9514nzqveH2S6waEgq8G0dAp73',
          'email': 'guiller.dlco@gmail.com',
          'image':
              'https://lh3.googleusercontent.com/a-/AOh14Gh_Oa5PTMyODnPrytoWf2U8AEeP0JOW40xjn6De9rA=s96-c',
          'status': true
        };
        expect(result, expectedMap);
      },
    );
  });
}
