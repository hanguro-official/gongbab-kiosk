import 'package:gongbab/domain/entities/check_in/kiosk_check_in.dart';
import 'package:gongbab/domain/entities/lookup/employee_match.dart';
import 'package:gongbab/domain/entities/status/kiosk_status.dart';

// UI State
sealed class PhoneNumberInputUiState {}

class Initial extends PhoneNumberInputUiState {}

class Loading extends PhoneNumberInputUiState {}

class KioskStatusLoaded extends PhoneNumberInputUiState {
  final KioskStatus kioskStatus;

  KioskStatusLoaded(this.kioskStatus);
}

class EmployeeCandidatesLoaded extends PhoneNumberInputUiState {
  final List<EmployeeMatch> employees;

  EmployeeCandidatesLoaded(this.employees);
}

class CheckInSuccess extends PhoneNumberInputUiState {
  final KioskCheckIn checkInResult;

  CheckInSuccess(this.checkInResult);
}

class Error extends PhoneNumberInputUiState {
  final String message;

  Error(this.message);
}
