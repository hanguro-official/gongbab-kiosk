// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_lookup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeLookupModel _$EmployeeLookupModelFromJson(Map<String, dynamic> json) =>
    EmployeeLookupModel(
      matches: (json['matches'] as List<dynamic>)
          .map((e) => EmployeeMatchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$EmployeeLookupModelToJson(
        EmployeeLookupModel instance) =>
    <String, dynamic>{
      'matches': instance.matches,
      'count': instance.count,
    };
