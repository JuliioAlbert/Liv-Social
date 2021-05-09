import 'package:geolocator/geolocator.dart';
import 'package:liv_social/features/data/datasource/google_maps_api_client.dart';
import 'package:liv_social/features/data/models/place.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:liv_social/features/domain/repositories/location_repository.dart';

class LocationRepositoryImpl extends LocationRepository {
  final GoogleMapsApiClient _googleMapsApiClient;

  LocationRepositoryImpl(this._googleMapsApiClient);

  @override
  Future<String> getAddress(LatLng latLng) async{
   try {
      final response = await _googleMapsApiClient
          .getAddress(latLng);
      if (response['results'] != null && response['results'].isNotEmpty) {
        return response['results'][0]['formatted_address'];
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Future<Position> getCurrentPosition() async =>
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

  @override
  Future<List<Place>> getPlaceBySearch(
      String query, LatLng currentPosition) async {
    final response = await _googleMapsApiClient.findPlaces(
      query,
      currentPosition,
    );
    final routes = response['candidates'] as List;
    final placesFound = <Place>[];
    routes.forEach((place) {
      placesFound.add(Place(
        place['name'],
        place['formatted_address'],
        LatLng(place['geometry']['location']['lat'],
            place['geometry']['location']['lng']),
      ));
    });
    return placesFound;
  }
}
