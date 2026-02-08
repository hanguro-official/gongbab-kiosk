import 'package:gongbab/domain/entities/status/kiosk_status.dart';

// UI State
sealed class PhoneNumberInputUiState {}

class PhoneNumberInputInitial extends PhoneNumberInputUiState {}

class PhoneNumberInputLoading extends PhoneNumberInputUiState {}

class PhoneNumberInputSuccess extends PhoneNumberInputUiState {
  final KioskStatus kioskStatus;

  PhoneNumberInputSuccess(this.kioskStatus);
}

class PhoneNumberInputError extends PhoneNumberInputUiState {
  final String message;

  PhoneNumberInputError(this.message);
}