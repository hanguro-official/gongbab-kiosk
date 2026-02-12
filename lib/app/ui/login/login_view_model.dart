import 'package:gongbab/data/device/device_info_service.dart';
import 'package:flutter/foundation.dart';
import 'package:gongbab/app/ui/login/login_event.dart';
import 'package:gongbab/app/ui/login/login_ui_state.dart';
import 'package:gongbab/domain/usecases/login_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';

@injectable
class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final AuthTokenManager _authTokenManager;
  final DeviceInfoService _deviceInfoService; // Injected service

  LoginUiState _uiState = Initial();

  LoginUiState get uiState => _uiState;

  LoginViewModel(this._loginUseCase, this._authTokenManager, this._deviceInfoService); // Updated constructor

  Future<void> onEvent(LoginEvent event) async {
    if (event is LoginButtonPressed) {
      _uiState = Loading();
      notifyListeners();

      final deviceId = await _deviceInfoService.getDeviceId();

      final result = await _loginUseCase.execute(
        code: '${event.phoneNumber}${event.password}',
        deviceType: 'KIOSK',
        deviceId: deviceId,
      );

      result.when(
        success: (loginEntity) async {
          if (loginEntity.restaurant != null) {
            await _authTokenManager.saveRestaurantInfo(
              loginEntity.restaurant!.id,
              // Assuming kioskCode is derived or hardcoded for now,
              // as it's not directly in LoginEntity.restaurant
              // For now, I'll use the hardcoded value from PhoneNumberInputViewModel
              // This should ideally come from the LoginModel or a config.
              loginEntity.kioskCode ?? 'UNDEFINED_KIOSK_CODE',
            );
          }
          _uiState = Success(loginEntity);
          notifyListeners();
        },
        failure: (String success, Map<String, dynamic>? data) {
          _uiState = Error('Login failed with code: $success');
          notifyListeners();
        },
        error: (message) {
          _uiState = Error(message);
          notifyListeners();
        },
      );
    }
  }

  void resetState() {
    _uiState = Initial();
    notifyListeners();
  }
}
