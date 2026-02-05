import 'package:gongbab/data/network/api_service.dart';
import 'package:gongbab/domain/entities/kiosk_status.dart'; // Domain Layer 엔티티 임포트
import 'package:gongbab/domain/repositories/kiosk_repository.dart'; // Domain Layer 리포지토리 인터페이스 임포트
import 'package:gongbab/domain/utils/result.dart';
import 'package:injectable/injectable.dart'; // injectable 임포트
import 'package:gongbab/domain/entities/common.dart'; // Import the domain entity
import 'package:gongbab/domain/entities/employee_lookup_entity.dart'; // Import new entity
import 'package:gongbab/domain/entities/employee_match_entity.dart'; // Import new entity

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
      failure: (code, data) => Result.failure(code, data),
      error: (error) => Result.error(error),
    );
  }

  @override
  Future<Result<Common>> checkTicket(String ticketId) async {
    final result = await _apiService.checkTicket(ticketId);
    return result.when(
      success: (model) => Result.success(Common(
        code: model.success, // Assuming Common.code maps to CommonModel.success
        data: model.data,
      )),
      failure: (code, data) => Result.failure(code, data),
      error: (error) => Result.error(error),
    );
  }

  @override
  Future<Result<EmployeeLookupEntity>> getEmployeeCandidates({
    required int restaurantId,
    required String phoneLastFour,
  }) async {
    final result = await _apiService.getEmployeeCandidates(
      restaurantId: restaurantId,
      phoneLastFour: phoneLastFour,
    );
    return result.when(
      success: (model) => Result.success(EmployeeLookupEntity(
        matches: model.matches
            .map((matchModel) => EmployeeMatchEntity(
                  employeeId: matchModel.employeeId,
                  name: matchModel.name,
                  companyId: matchModel.companyId,
                  companyName: matchModel.companyName,
                ))
            .toList(),
        count: model.count,
      )),
      failure: (code, data) => Result.failure(code, data),
      error: (error) => Result.error(error),
    );
  }
}
