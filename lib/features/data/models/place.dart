import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String? name;
  final String address;
  final LatLng latLng;

  Place(this.address, this.name, this.latLng);
}
