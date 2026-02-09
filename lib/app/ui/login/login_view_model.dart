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

  LoginUiState _uiState = Initial();

  LoginUiState get uiState => _uiState;

  LoginViewModel(this._loginUseCase, this._authTokenManager);

  Future<void> onEvent(LoginEvent event) async {
    if (event is LoginButtonPressed) {
      _uiState = Loading();
      notifyListeners();

      final result = await _loginUseCase.execute(
        code: '${event.phoneNumber}${event.password}',
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
              'FCT-092',
            );
          }
          _uiState = Success(loginEntity);
        },
        failure: (String success, Map<String, dynamic>? data) {
          _uiState = Error('Login failed with code: $success');
        },
        error: (message) {
          _uiState = Error(message);
        },
      );
      notifyListeners();
    }
  }

  void resetState() {
    _uiState = Initial();
    notifyListeners();
  }
}
