import 'package:gongbab/data/network/api_service.dart';
import 'package:gongbab/domain/entities/check_in/company.dart'; // Import new entity
import 'package:gongbab/domain/entities/check_in/employee.dart'; // Import new entity
import 'package:gongbab/domain/entities/check_in/kiosk_check_in.dart'; // Import new entity
import 'package:gongbab/domain/entities/lookup/employee_lookup.dart'; // Import new entity
import 'package:gongbab/domain/entities/lookup/employee_match.dart'; // Import new entity
import 'package:gongbab/domain/entities/status/kiosk_status.dart'; // Domain Layer 엔티티 임포트
import 'package:gongbab/domain/repositories/kiosk_repository.dart'; // Domain Layer 리포지토리 인터페이스 임포트
import 'package:gongbab/domain/utils/result.dart';
import 'package:injectable/injectable.dart'; // injectable 임포트

@LazySingleton(as: KioskRepository) // KioskRepository 인터페이스의 구현체로 지연 로딩 싱글톤 등록
class KioskRepositoryImpl implements KioskRepository { // KioskRepository 인터페이스 구현
  final ApiService _apiService;

  KioskRepositoryImpl(this._apiService);

  @override
  Future<Result<KioskStatus>> getKioskStatus({
    required int restaurantId,
    required String kioskCode,
    required String clientTime,
  }) async {
    final result = await _apiService.getKioskStatus(
      restaurantId: restaurantId,
      kioskCode: kioskCode,
      clientTime: clientTime,
    );
    return result.when(
      success: (model) => Result.success(KioskStatus(
        status: model.status,
        serverTime: model.serverTime,
      )),
      failure: (success, data) => Result.failure(success, data),
      error: (error) => Result.error(error),
    );
  }

  @override
  Future<Result<EmployeeLookup>> getEmployeeCandidates({
    required int restaurantId,
    required String phoneLastFour,
  }) async {
    final result = await _apiService.getEmployeeCandidates(
      restaurantId: restaurantId,
      phoneLastFour: phoneLastFour,
    );
    return result.when(
      success: (model) => Result.success(EmployeeLookup(
        matches: model.matches
            .map((matchModel) => EmployeeMatch(
                  employeeId: matchModel.employeeId,
                  name: matchModel.name,
                  companyId: matchModel.companyId,
                  companyName: matchModel.companyName,
                ))
            .toList(),
        count: model.count,
      )),
      failure: (success, data) => Result.failure(success, data),
      error: (error) => Result.error(error),
    );
  }

  @override
  Future<Result<KioskCheckIn>> kioskCheckIn({
    required int restaurantId,
    required int employeeId,
    required String kioskCode,
    required String clientTime,
  }) async {
    final result = await _apiService.kioskCheckIn(
      restaurantId: restaurantId,
      employeeId: employeeId,
      kioskCode: kioskCode,
      clientTime: clientTime,
    );
    return result.when(
      success: (model) => Result.success(KioskCheckIn(
        result: model.result,
        mealLogId: model.mealLogId,
        mealType: model.mealType,
        mealDate: model.mealDate,
        employee: Employee(
          id: model.employee.id,
          name: model.employee.name,
        ),
        company: Company(
          id: model.company.id,
          name: model.company.name,
        ),
        eatenAt: model.eatenAt,
        message: model.message,
      )),
      failure: (success, data) => Result.failure(success, data),
      error: (error) => Result.error(error),
    );
  }
}
