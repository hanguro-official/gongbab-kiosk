import 'package:gongbab/domain/entities/auth/login_entity.dart';
import 'package:gongbab/domain/entities/check_in/kiosk_check_in.dart'; // Import new entity
import 'package:gongbab/domain/entities/lookup/employee_lookup.dart'; // Import new entity
import 'package:gongbab/domain/entities/status/kiosk_status.dart';
import 'package:gongbab/domain/utils/result.dart';

abstract class KioskRepository {
  Future<Result<KioskStatus>> getKioskStatus({
    required int restaurantId,
    required String kioskCode,
    required String clientTime,
  }); // 키오스크 상태 조회
  Future<Result<EmployeeLookup>> getEmployeeCandidates({
    required int restaurantId,
    required String phoneLastFour,
  });
  Future<Result<KioskCheckIn>> kioskCheckIn({
    required int restaurantId,
    required int employeeId,
    required String kioskCode,
    required String clientTime,
  });
}