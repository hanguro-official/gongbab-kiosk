import 'package:json_annotation/json_annotation.dart';
import 'package:gongbab/data/models/employee_match_model.dart';

part 'employee_lookup_model.g.dart';

@JsonSerializable()
class EmployeeLookupModel {
  final List<EmployeeMatchModel> matches;
  final int count;

  EmployeeLookupModel({
    required this.matches,
    required this.count,
  });

  factory EmployeeLookupModel.fromJson(Map<String, dynamic> json) => _$EmployeeLookupResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeLookupResponseModelToJson(this);
}