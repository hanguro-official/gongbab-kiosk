import 'package:gongbab/domain/entities/kiosk_status.dart';
import 'package:gongbab/domain/repositories/kiosk_repository.dart';

class GetKioskStatusUseCase {
  final KioskRepository repository;

  GetKioskStatusUseCase(this.repository);

  Future<KioskStatus> call() {
    return repository.getKioskStatus();
  }
}
