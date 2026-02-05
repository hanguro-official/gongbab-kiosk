import 'package:json_annotation/json_annotation.dart';
import 'package:gongbab/data/models/employee_match_model.dart';

part 'employee_lookup_response_model.g.dart';

@JsonSerializable()
class EmployeeLookupResponseModel {
  final List<EmployeeMatchModel> matches;
  final int count;

  EmployeeLookupResponseModel({
    required this.matches,
    required this.count,
  });

  factory EmployeeLookupResponseModel.fromJson(Map<String, dynamic> json) => _$EmployeeLookupResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeLookupResponseModelToJson(this);
}