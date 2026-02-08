import 'package:json_annotation/json_annotation.dart';
import 'package:gongbab/data/models/check_in/employee_model.dart';
import 'package:gongbab/data/models/check_in/company_model.dart';

part 'kiosk_check_in_model.g.dart';

@JsonSerializable()
class KioskCheckInModel {
  final String result;
  final int mealLogId;
  final String mealType;
  final String mealDate;
  final EmployeeModel employee;
  final CompanyModel company;
  final String eatenAt;
  final String message;

  KioskCheckInModel({
    required this.result,
    required this.mealLogId,
    required this.mealType,
    required this.mealDate,
    required this.employee,
    required this.company,
    required this.eatenAt,
    required this.message,
  });

  factory KioskCheckInModel.fromJson(Map<String, dynamic> json) => _$KioskCheckInModelFromJson(json);
  Map<String, dynamic> toJson() => _$KioskCheckInModelToJson(this);
}