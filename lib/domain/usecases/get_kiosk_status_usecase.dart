import 'package:gongbab/domain/entities/kiosk_status.dart';
import 'package:gongbab/domain/repositories/kiosk_repository.dart';
import 'package:gongbab/domain/utils/result.dart';

class GetKioskStatusUseCase {
  final KioskRepository repository;

  GetKioskStatusUseCase(this.repository);

  Future<Result<KioskStatus>> execute({
    required int restaurantId,
    required String kioskCode,
    required String clientTime,
  }) {
    return repository.getKioskStatus(
      restaurantId: restaurantId,
      kioskCode: kioskCode,
      clientTime: clientTime,
    );
  }
}
