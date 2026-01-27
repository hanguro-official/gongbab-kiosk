import 'package:gongbab/data/network/api_service.dart';
import 'package:gongbab/data/models/kiosk_status_model.dart';
import 'package:gongbab/domain/entities/kiosk_status.dart'; // Domain Layer 엔티티 임포트
import 'package:gongbab/domain/repositories/kiosk_repository.dart'; // Domain Layer 리포지토리 인터페이스 임포트

class KioskRepositoryImpl implements KioskRepository { // KioskRepository 인터페이스 구현
  final ApiService _apiService;

  KioskRepositoryImpl(this._apiService);

  @override
  Future<KioskStatus> getKioskStatus() async {
    final response = await _apiService.getKioskStatus();
    // Data Layer 모델을 Domain Layer 엔티티로 변환
    final model = KioskStatusModel.fromJson(response);
    return KioskStatus(
      status: model.status,
      message: model.message,
      location: model.location,
      lastUpdated: model.lastUpdated,
    );
  }

  @override
  Future<void> checkTicket(String ticketId) async {
    await _apiService.checkTicket(ticketId);
    // API 호출 후 반환값이 없으므로 void 처리
  }
}
