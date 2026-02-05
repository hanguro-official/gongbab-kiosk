import 'package:flutter/foundation.dart';
import 'package:gongbab/domain/entities/kiosk_status.dart';
import 'package:gongbab/domain/usecases/get_kiosk_status_usecase.dart';
import 'package:injectable/injectable.dart';

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

// UI Event
sealed class PhoneNumberInputUiEvent {}

class FetchKioskStatus extends PhoneNumberInputUiEvent {}

@injectable
class PhoneNumberInputViewModel extends ChangeNotifier {
  final GetKioskStatusUseCase _getKioskStatusUseCase;

  PhoneNumberInputViewModel(this._getKioskStatusUseCase);

  PhoneNumberInputUiState _uiState = PhoneNumberInputInitial();
  PhoneNumberInputUiState get uiState => _uiState;

  void _setUiState(PhoneNumberInputUiState newState) {
    _uiState = newState;
    notifyListeners();
  }

  void onEvent(PhoneNumberInputUiEvent event) {
    switch (event) {
      case FetchKioskStatus():
        _fetchKioskStatus();
        break;
    }
  }

  Future<void> _fetchKioskStatus() async {
    _setUiState(PhoneNumberInputLoading());

    // Dummy data for testing
    const int restaurantId = 1;
    const String kioskCode = "FCT-092";
    const String clientTime = "2026-02-01T08:40:12";

    final result = await _getKioskStatusUseCase.execute(
      restaurantId: restaurantId,
      kioskCode: kioskCode,
      clientTime: clientTime,
    );

    result.when(
      success: (kioskStatus) {
        _setUiState(PhoneNumberInputSuccess(kioskStatus));
      },
      failure: (code, data) {
        _setUiState(PhoneNumberInputError('Failed to fetch kiosk status: $code'));
      },
      error: (error) {
        _setUiState(PhoneNumberInputError('Error fetching kiosk status: $error'));
      },
    );
  }
}