// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KioskStatusModel _$KioskStatusModelFromJson(Map<String, dynamic> json) =>
    KioskStatusModel(
      status: json['status'] as String,
      serverTime: json['serverTime'] as String,
    );

Map<String, dynamic> _$KioskStatusModelToJson(KioskStatusModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'serverTime': instance.serverTime,
    };
