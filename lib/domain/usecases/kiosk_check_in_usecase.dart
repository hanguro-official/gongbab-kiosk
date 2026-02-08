import 'package:gongbab/domain/entities/check_in/kiosk_check_in.dart';
import 'package:gongbab/domain/repositories/kiosk_repository.dart';
import 'package:gongbab/domain/utils/result.dart';

class KioskCheckInUseCase {
  final KioskRepository repository;

  KioskCheckInUseCase(this.repository);

  Future<Result<KioskCheckIn>> execute({
    required int restaurantId,
    required int employeeId,
    required String kioskCode,
    required String clientTime,
  }) {
    return repository.kioskCheckIn(
      restaurantId: restaurantId,
      employeeId: employeeId,
      kioskCode: kioskCode,
      clientTime: clientTime,
    );
  }
}