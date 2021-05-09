import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapsApiClient {
  final String _baseUrl = 'https://maps.googleapis.com/maps/api';
  final String _apiKey = 'AIzaSyC5w0fmK1CYAiY8JvlFRmTASVepmwE9DjM';

  String _getAddressEndpoint(LatLng latLng) =>
      '/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$_apiKey';

  String _findPlacesEndpoint(String query, LatLng latLng) =>
      '/place/findplacefromtext/json?input=$query&inputtype=textquery&fields=formatted_address,name,geometry&locationbias=point:${latLng.latitude},${latLng.longitude}&key=$_apiKey';

  final http.Client httpClient;

  GoogleMapsApiClient({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Uri getUri(String api) => Uri.parse(_baseUrl + api);

  Future<Map> getAddress(LatLng latLng) {
    return _callGetApi(
      endpoint: _getAddressEndpoint(latLng),
    );
  }

  Future<Map> findPlaces(String query, LatLng latLng) {
    return _callGetApi(
      endpoint: _findPlacesEndpoint(query, latLng),
    );
  }

  Future<Map> _callGetApi({
    required String endpoint,
  }) async {
    print('Flutter GET Request: $_baseUrl$endpoint}');

    final response = await httpClient.get(
      getUri(endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Flutter GET Response: \n${jsonDecode(response.body)}');

    return jsonDecode(response.body);
  }
}
