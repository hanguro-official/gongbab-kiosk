// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_lookup_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeLookupResponseModel _$EmployeeLookupResponseModelFromJson(
        Map<String, dynamic> json) =>
    EmployeeLookupResponseModel(
      matches: (json['matches'] as List<dynamic>)
          .map((e) => EmployeeMatchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$EmployeeLookupResponseModelToJson(
        EmployeeLookupResponseModel instance) =>
    <String, dynamic>{
      'matches': instance.matches,
      'count': instance.count,
    };
