import 'package:json_annotation/json_annotation.dart';

part 'kiosk_status_model.g.dart'; // 코드 생성기가 생성할 파일

@JsonSerializable()
class KioskStatusModel {
  final String status;
  final String serverTime;

  KioskStatusModel({
    required this.status,
    required this.serverTime,
  });

  factory KioskStatusModel.fromJson(Map<String, dynamic> json) =>
      _$KioskStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$KioskStatusModelToJson(this);
}
