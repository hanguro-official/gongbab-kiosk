import 'package:flutter/foundation.dart';
import 'package:gongbab/domain/usecases/get_kiosk_status_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_ui_state.dart'; // Import the new state file
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_event.dart'; // Import the new event file

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

  void onEvent(PhoneNumberInputEvent event) {
    switch (event) {
      case FetchKioskStatus():
        _fetchKioskStatus();
        break;
    }
  }

  Future<void> _fetchKioskStatus() async {
    _setUiState(PhoneNumberInputLoading());

    // Dummy data for testing
    const int restaurantId = 092;
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