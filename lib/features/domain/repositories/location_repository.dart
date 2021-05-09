import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liv_social/features/data/models/place.dart';

abstract class LocationRepository {
  Future<String> getAddress(LatLng latLng);

  Future<Position> getCurrentPosition();

  Future<List<Place>> getPlaceBySearch(String query, LatLng currentPosition);
}
