import 'package:json_annotation/json_annotation.dart';

part 'employee_match_model.g.dart';

@JsonSerializable()
class EmployeeMatchModel {
  final int employeeId;
  final String name;
  final int companyId;
  final String companyName;

  EmployeeMatchModel({
    required this.employeeId,
    required this.name,
    required this.companyId,
    required this.companyName,
  });

  factory EmployeeMatchModel.fromJson(Map<String, dynamic> json) => _$EmployeeMatchModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeMatchModelToJson(this);
}