import 'package:json_annotation/json_annotation.dart';

import 'package:liv_social/core/utils/utils.dart';

part 'activity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
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
  LocationPlace locationPlace;

  Activity(
    this.ownerId,
    this.ownerName,
    this.title,
    this.subtitle,
    this.details,
    this.expectedDate,
    this.locationPlace,
  );

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class LocationPlace {
  String? name;
  late String address;
  late double latitude;
  late double longitude;

  LocationPlace(
    this.name,
    this.address,
    this.latitude,
    this.longitude,
  );

  factory LocationPlace.fromJson(Map<String, dynamic> json) =>
      _$LocationPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$LocationPlaceToJson(this);
}
