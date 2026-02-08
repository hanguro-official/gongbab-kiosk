// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeMatchModel _$EmployeeMatchModelFromJson(Map<String, dynamic> json) =>
    EmployeeMatchModel(
      employeeId: (json['employeeId'] as num).toInt(),
      name: json['name'] as String,
      companyId: (json['companyId'] as num).toInt(),
      companyName: json['companyName'] as String,
    );

Map<String, dynamic> _$EmployeeMatchModelToJson(EmployeeMatchModel instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'name': instance.name,
      'companyId': instance.companyId,
      'companyName': instance.companyName,
    };
