import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liv_social/features/data/models/place.dart';
import 'package:liv_social/features/domain/repositories/location_repository.dart';

class GetLocationUseCase {
  GetLocationUseCase(this._locationRepository);
  final LocationRepository _locationRepository;

  Future<List<Place>> searchPlace(String query, LatLng currentPosition) {
    return _locationRepository.getPlaceBySearch(query, currentPosition);
  }

  Future<String> getAddress(LatLng position) {
    return _locationRepository.getAddress(position);
  }

  Future<LatLng?> getCurrentLocation() async {
    final position = await _locationRepository.getCurrentPosition();

    return LatLng(position.latitude, position.longitude);
  }
}
