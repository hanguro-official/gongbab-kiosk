import 'package:gongbab/domain/entities/lookup/employee_match.dart';

class EmployeeLookup {
  final List<EmployeeMatch> matches;
  final int count;

  EmployeeLookup({
    required this.matches,
    required this.count,
  });
}