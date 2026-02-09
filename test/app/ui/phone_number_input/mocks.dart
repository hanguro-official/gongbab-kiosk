import 'package:mockito/annotations.dart';
import 'package:gongbab/domain/usecases/get_kiosk_status_usecase.dart';
import 'package:gongbab/domain/usecases/get_employee_candidates_usecase.dart';
import 'package:gongbab/domain/usecases/kiosk_check_in_usecase.dart';

@GenerateMocks([
  GetKioskStatusUseCase,
  GetEmployeeCandidatesUseCase,
  KioskCheckInUseCase,
])
void main() {}
