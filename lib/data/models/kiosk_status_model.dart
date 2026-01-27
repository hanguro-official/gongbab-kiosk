import 'package:json_annotation/json_annotation.dart';

part 'kiosk_status_model.g.dart'; // 코드 생성기가 생성할 파일

@JsonSerializable()
class KioskStatusModel {
  final String status;
  final String message;
  final String location;
  @JsonKey(name: 'last_updated') // JSON 키와 Dart 필드 이름이 다를 경우 사용
  final DateTime lastUpdated;

  KioskStatusModel({
    required this.status,
    required this.message,
    required this.location,
    required this.lastUpdated,
  });

  factory KioskStatusModel.fromJson(Map<String, dynamic> json) =>
      _$KioskStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$KioskStatusModelToJson(this);
}
