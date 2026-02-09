import 'package:gongbab/domain/entities/check_in/kiosk_check_in.dart';
import 'package:gongbab/domain/entities/lookup/employee_lookup.dart';
import 'package:gongbab/domain/entities/status/kiosk_status.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gongbab/domain/utils/result.dart';
import 'package:mockito/mockito.dart';

void registerDummyFallbacks() {
  // Provide dummy values for specific Result<T> types
  provideDummy(Result<KioskStatus>.success(KioskStatus(status: '', serverTime: '')));
  provideDummy(Result<EmployeeLookup>.success(EmployeeLookup(matches: [], count: 0)));
  provideDummy(Result<KioskCheckIn>.success(KioskCheckIn(result: '', message: '', mealLogId: 0, mealType: '', mealDate: '', eatenAt: '')));
  provideDummy(List<ConnectivityResult>.from([]));
}
