// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_check_in_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KioskCheckInModel _$KioskCheckInModelFromJson(Map<String, dynamic> json) =>
    KioskCheckInModel(
      result: json['result'] as String,
      mealLogId: (json['mealLogId'] as num).toInt(),
      mealType: json['mealType'] as String,
      mealDate: json['mealDate'] as String,
      employee:
          EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>),
      company: CompanyModel.fromJson(json['company'] as Map<String, dynamic>),
      eatenAt: json['eatenAt'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$KioskCheckInModelToJson(KioskCheckInModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'mealLogId': instance.mealLogId,
      'mealType': instance.mealType,
      'mealDate': instance.mealDate,
      'employee': instance.employee,
      'company': instance.company,
      'eatenAt': instance.eatenAt,
      'message': instance.message,
    };
