import 'package:json_annotation/json_annotation.dart';

import 'package:liv_social/core/utils/utils.dart';

part 'activity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class Activity {
  String? uid;
  late String ownerId;
  late String ownerName;
  late String title;
  late String subtitle;
  late String details;
  String? image;
  bool status = true;
  @JsonKey(fromJson: Utils.fromDateFormat)
  late DateTime? expectedDate;
  late LocationPlace locationPlace;

  Activity.empty();

  Activity({
    this.uid,
    required this.ownerId,
    required this.ownerName,
    required this.title,
    required this.subtitle,
    required this.details,
    this.image,
    this.status = true,
    this.expectedDate,
    required this.locationPlace,
  });

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class LocationPlace {
  String? name;
  late String address;
  late double latitude;
  late double longitude;

  LocationPlace({
    this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory LocationPlace.fromJson(Map<String, dynamic> json) =>
      _$LocationPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$LocationPlaceToJson(this);
}
