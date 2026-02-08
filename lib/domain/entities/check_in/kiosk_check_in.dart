import 'package:gongbab/domain/entities/check_in/employee.dart';
import 'package:gongbab/domain/entities/check_in/company.dart';

class KioskCheckIn {
  final String result;
  final int mealLogId;
  final String mealType;
  final String mealDate;
  final Employee employee;
  final Company company;
  final String eatenAt;
  final String message;

  KioskCheckIn({
    required this.result,
    required this.mealLogId,
    required this.mealType,
    required this.mealDate,
    required this.employee,
    required this.company,
    required this.eatenAt,
    required this.message,
  });
}