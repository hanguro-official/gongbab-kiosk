import 'package:gongbab/domain/entities/employee_match_entity.dart';

class EmployeeLookupEntity {
  final List<EmployeeMatchEntity> matches;
  final int count;

  EmployeeLookupEntity({
    required this.matches,
    required this.count,
  });
}