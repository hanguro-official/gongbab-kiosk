// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KioskStatusModel _$KioskStatusModelFromJson(Map<String, dynamic> json) =>
    KioskStatusModel(
      status: json['status'] as String,
      message: json['message'] as String,
      location: json['location'] as String,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$KioskStatusModelToJson(KioskStatusModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'location': instance.location,
      'last_updated': instance.lastUpdated.toIso8601String(),
    };
