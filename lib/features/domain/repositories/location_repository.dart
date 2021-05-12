import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liv_social/features/data/models/place.dart';

abstract class LocationRepository {
  /// Get the address of a position [LatLng]
  Future<String> getAddress(LatLng latLng);

  /// Get the current [Position] of the device
  Future<Position> getCurrentPosition();

  /// Get possible addresses [List<Place>] from the query made by `query` and the indicated `currentPosition`
  Future<List<Place>> getPlaceBySearch(String query, LatLng currentPosition);
}
