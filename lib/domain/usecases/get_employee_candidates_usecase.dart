import 'package:gongbab/domain/entities/lookup/employee_lookup.dart';
import 'package:gongbab/domain/repositories/kiosk_repository.dart';
import 'package:gongbab/domain/utils/result.dart';

class GetEmployeeCandidatesUseCase {
  final KioskRepository repository;

  GetEmployeeCandidatesUseCase(this.repository);

  Future<Result<EmployeeLookup>> execute({
    required int restaurantId,
    required String phoneLastFour,
  }) {
    return repository.getEmployeeCandidates(
      restaurantId: restaurantId,
      phoneLastFour: phoneLastFour,
    );
  }
}