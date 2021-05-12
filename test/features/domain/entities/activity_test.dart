import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:liv_social/features/domain/entities/activity.dart';

import '../../../sources/source_reader.dart';

void main() {
  final activity = Activity(
    details: 'A whole day of celebrations',
    expectedDate: DateTime(2021, 05, 12, 04, 18, 0),
    image:
        'https://firebasestorage.googleapis.com/v0/b/liv-social.appspot.com/o/activity%2Fc-postedin-image-57673.jpeg?alt=media&token=654acc95-7fe9-45bd-894c-de725656bb9a',
    locationPlace: LocationPlace(
      address: 'Playa Agua Dulce',
      latitude: -12.1612338,
      longitude: -77.0265804,
    ),
    ownerId: '7F9514nzqveH2S6waEgq8G0dAp73',
    ownerName: 'Guillermo De La Cruz Onton',
    status: true,
    subtitle: 'To enjoy with the family',
    title: 'Festival on the beach',
    uid: '310ba83d-a93f-4509-ade3-f76559c54d95',
  );

  test(
    'should be a class of Activity entity',
    () async {
      expect(activity, isA<Activity>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(source('activity_sample.json'));
        final result = Activity.fromJson(jsonMap);
        expect(result.toJson(), activity.toJson());
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = activity.toJson();
        final expectedMap = {
          'details': 'A whole day of celebrations',
          'expectedDate': '2021-05-12T04:18:00.000',
          'image':
              'https://firebasestorage.googleapis.com/v0/b/liv-social.appspot.com/o/activity%2Fc-postedin-image-57673.jpeg?alt=media&token=654acc95-7fe9-45bd-894c-de725656bb9a',
          'locationPlace': {
            'address': 'Playa Agua Dulce',
            'latitude': -12.1612338,
            'longitude': -77.0265804,
          },
          'ownerId': '7F9514nzqveH2S6waEgq8G0dAp73',
          'ownerName': 'Guillermo De La Cruz Onton',
          'status': true,
          'subtitle': 'To enjoy with the family',
          'title': 'Festival on the beach',
          'uid': '310ba83d-a93f-4509-ade3-f76559c54d95',
        };
        expect(result, expectedMap);
      },
    );
  });
}
