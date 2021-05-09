import 'package:json_annotation/json_annotation.dart';

import 'package:liv_social/core/utils/utils.dart';

part 'activity.g.dart';

@JsonSerializable(anyMap: true)
class Activity {
  late String uid;
  late String ownerId;
  late String ownerName;
  late String title;
  late String subtitle;
  late String details;
  late List<String>? images;
  bool status = true;
  @JsonKey(fromJson: Utils.fromTimestamp)
  late DateTime? expectedDate;
  late LocationPlace locationPlace;

  Activity(
    this.ownerId,
    this.ownerName,
    this.title,
    this.subtitle,
    this.details,
    this.images,
    this.expectedDate,
    this.locationPlace,
  );

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}

@JsonSerializable(anyMap: true)
class LocationPlace {
  late String? name;
  late String address;
  late double latitude;
  late double longitude;

  LocationPlace();

  factory LocationPlace.fromJson(Map<String, dynamic> json) =>
      _$LocationPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$LocationPlaceToJson(this);
}
