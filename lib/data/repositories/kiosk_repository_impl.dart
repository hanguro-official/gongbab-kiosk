import 'package:gongbab/data/network/api_service.dart';
import 'package:gongbab/data/models/kiosk_status_model.dart';

// 이 클래스는 나중에 Domain Layer의 추상 리포지토리 인터페이스를 구현하게 됩니다.
class KioskRepositoryImpl {
  final ApiService _apiService;

  KioskRepositoryImpl(this._apiService);

  Future<KioskStatusModel> getKioskStatus() async {
    final response = await _apiService.getKioskStatus();
    // 여기서는 Map<String, dynamic>을 직접 KioskStatusModel로 변환합니다.
    // 실제 앱에서는 에러 처리 로직이 더 추가될 수 있습니다.
    return KioskStatusModel.fromJson(response);
  }

  Future<Map<String, dynamic>> checkTicket(String ticketId) async {
    final response = await _apiService.checkTicket(ticketId);
    // 식권 체크인 응답은 간단한 Map으로 반환하도록 가정합니다.
    return response;
  }
}
