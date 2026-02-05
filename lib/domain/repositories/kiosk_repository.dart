import 'package:gongbab/domain/entities/common.dart';
import 'package:gongbab/domain/entities/kiosk_status.dart';
import 'package:gongbab/domain/utils/result.dart';

abstract class KioskRepository {
  Future<Result<KioskStatus>> getKioskStatus({
    required int restaurantId,
    required String kioskCode,
    required String clientTime,
  }); // 키오스크 상태 조회
  Future<Result<Common>> checkTicket(String ticketId); // 식권 체크인 후 반환값이 없을 수 있으므로 void로 가정
}
