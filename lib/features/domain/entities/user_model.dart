import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(anyMap: true, includeIfNull: false)
class UserModel {
  late String name;
  late String uid;
  late String email;
  late String? image;
  bool status = false;

  UserModel.empty();

  UserModel({
    required this.name,
    required this.uid,
    required this.email,
    this.image,
    this.status = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
