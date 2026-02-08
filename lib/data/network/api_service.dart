import 'package:gongbab/data/models/employee_lookup_model.dart'; // Import new model
import 'package:gongbab/data/models/kiosk_check_in_model.dart'; // Import new model
import 'package:gongbab/data/models/kiosk_status_model.dart';
import 'package:gongbab/data/network/app_api_client.dart';
import 'package:gongbab/data/network/rest_api_client.dart';
import 'package:gongbab/domain/utils/result.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiService {
  final AppApiClient _appApiClient;

  ApiService(this._appApiClient);

  Future<Result<KioskStatusModel>> getKioskStatus({
    required int restaurantId,
    required String kioskCode,
    required String clientTime,
  }) async {
    return _appApiClient.request(
      method: RestMethod.post, // Changed to POST
      path: '/api/v1/restaurants/$restaurantId/kiosks/heartbeat',
      data: { // Added request body
        'kioskCode': kioskCode,
        'clientTime': clientTime,
      },
      fromJson: KioskStatusModel.fromJson,
    );
  }

  Future<Result<EmployeeLookupModel>> getEmployeeCandidates({
    required int restaurantId,
    required String phoneLastFour,
  }) async {
    return _appApiClient.request(
      method: RestMethod.get,
      path: '/api/v1/restaurants/$restaurantId/kiosk/employees/lookup',
      queryParameters: {
        'phoneLastFour': phoneLastFour,
      },
      fromJson: EmployeeLookupModel.fromJson,
    );
  }

  Future<Result<KioskCheckInModel>> kioskCheckIn({
    required int restaurantId,
    required int employeeId,
    required String kioskCode,
    required String clientTime,
  }) async {
    return _appApiClient.request(
      method: RestMethod.post,
      path: '/api/v1/restaurants/$restaurantId/kiosk/check-in',
      data: {
        'employeeId': employeeId,
        'kioskCode': kioskCode,
        'clientTime': clientTime,
      },
      fromJson: KioskCheckInModel.fromJson,
    );
  }
}